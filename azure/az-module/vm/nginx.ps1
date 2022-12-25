Param (
  [Parameter(Mandatory, HelpMessage="Name of the virtual machine that you want to deploy")]
  [string] $VmName,
  [Parameter(Mandatory, HelpMessage="What type of action do you want to perform? New or Remove?")]
  [ValidateSet("New", "Remove")]
  [string] $Action
)

$ResourceGroupName = "franchutes"

If ($Action -like 'New') {
  # Securing the VM
  $User = "devuser"
  $SecurePassword = ConvertTo-SecureString "abc123." -AsPlainText -Force
  $Credential = New-Object System.Management.Automation.PSCredential ($User, $SecurePassword)

  # Make sure to have the franchutes AzResourceGroup created
  Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction Stop

  New-AzVM -ResourceGroupName $ResourceGroupName `
    -Name $VmName `
    -Image UbuntuLTS `
    -Location (Get-AzResourceGroup -ResourceGroupName $ResourceGroupName).Location `
    -PublicIpSku Basic `
    -PublicIpAddressName 'testing-ubuntu' `
    -Credential $Credential `
    -Size Standard_B1s `
    -OpenPorts 80,22 `
    -SshKeyName 'ubuntu-key'

  Start-Sleep -Seconds 5

  # The CommandId must be: RunShellScript or RunPowerShellScript
  Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -Name $VmName -CommandId RunShellScript -ScriptString "apt-get update -y && apt-get install --yes nginx"

  (Invoke-WebRequest -Uri "http://$($(Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name 'testing-ubuntu').DnsSettings.Fqdn):80").RawContent
} Else {
  # Removing VM, NetworkInterface, Disk, VirtualNetwork, NetworkSecurityGroup, PublicIpAddress
  $Vm = (Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName)
  Remove-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName -Force

  $NetworkSecurityGroups = New-Object System.Collections.Generic.HashSet[string]
  $VirtualNetworks = New-Object System.Collections.Generic.HashSet[string]
  $PublicIPAddresses = New-Object System.Collections.Generic.HashSet[string]

  $Vm.NetworkProfile.NetworkInterfaces.Id | ForEach-Object {
    [string] $NetworkName = $_.Substring($_.LastIndexOf('/') + 1)
    $NetworkInterface = (Get-AzNetworkInterface -ResourceGroupName franchutes -Name $NetworkName)
    [string] $NetworkSecurityGroupID = $NetworkInterface.NetworkSecurityGroup.Id

    $NetworkInterface.IpConfigurations | ForEach-Object {
# /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/virtualNetworks/$VirtualNetworkName/subnets/$SubnetName
      [string] $VirtualNetworkID = $_.Subnet.Id.Split('/')[8]
# /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/publicIPAddresses/$PublicIpAddress
      [string] $PublicIpAddress = $_.PublicIpAddress.Id.Split('/')[8]

      $Virtualnetworks.Add($VirtualNetworkID)
      $PublicIpAddresses.Add($PublicIpAddress)
    }

# /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/networkSecurityGroups/$NetworkSecurityGroup
    $NetworkSecurityGroups.Add($NetworkSecurityGroupID.Split('/')[8])

    Remove-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Name $NetworkName -Force
  }

  Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $Vm.StorageProfile.OsDisk.Name | Remove-AzDisk -Force
  $NetworkSecurityGroups | ForEach-Object { Remove-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Name $_ -Force }
  $PublicIpAddresses | ForEach-Object { Remove-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $_ -Force }
  $VirtualNetworks | ForEach-Object { Remove-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $_ -Force }

  # Check if there is something else
  Get-AzResource -ResourceGroupName $ResourceGroupName
}