# How to create a simple Virtual Machine with Azure
#
# It is mandatory to specify:
#
# - ResourceGroupName
# - Name
# - Location
# - Credential
# - Image
# 
# After we have created the Azure Virtual Machine, we can:
#
# - RemoveAzVm
# - StartAzVm
# - StopAzVm
# - Restart-AzVm
# - UpdateAzVm
#
# Trusted launch https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch
#
# Not working yet
New-AzVM -ResourceGroupName franchutes `
  -Name 'testing-ubuntu' `
  -Location (Get-AzResourceGroup -Name franchutes).Location `
  -Size Standard_B1s `
  -ImageReferenceId "$publisher`:$imageOffer`:$sku`:$version" `
  -OpenPorts 80,22 `
  -GenerateSshKey `
  -SshKeyName 'ubuntu-key' `
  -Credential (Get-Credential -UserName devuser) `
  -PublicIpAddressName "testing-ubuntu-ip" `
  -AsJob

New-AzVM -ResourceGroupName franchutes `
  -Name 'testing-ubuntults' `
  -Location (Get-AzResourceGroup -Name franchutes).Location `
  -Size Standard_B1s `
  -Image UbuntuLTS `
  -OpenPorts 80,22 `
  -SshKeyname 'ubuntu-key' `
  -Credential (Get-Credential -UserName devuser) `
  -PublicIpSku Basic `
  -PublicIpAddressName 'testing-ubuntu-ip'

# Get-Command -Verb Get -Noun AzVM* -> We use this command to get a list of all the commands that we can use to extract properties of the VM that we have just created
Get-AzVM -Name test-ubuntults -ResourceGroupname franchutes | Get-AzVMSize

# Getting the DNS of a VM that we have already deployed
(Get-AzPublicIpAddress -ResourceGroupName franchutes -Name 'testing-ubuntu-ip').DnsSettings.Fqdn
(Get-AzPublicIpAddress -ResourceGroupName franchutes -Name 'testing-ubuntu-ip').IpAddress

# Invoking remote commands
Invoke-AzVMRunCommand -ResourceGroupName franchutes -VMName 'testing-ubuntults' -CommandId RunShellScript -ScriptString 'sudo apt-get update && sudo apt-get install -y nginx'

(Invoke-WebRequest -URI http://$($(Get-AzPublicIpAddress -ResourceGroupName franchutes -Name 'testing-ubuntu-ip').DnsSettings.Fqdn):80).Content

Get-AzResource -ResourceGroupName franchutes | Format-Table
# Removing everything (VM, NetworkInterfaces, disk, VirtualNetwork, Network Security Group, Public IP Address)
Remove-AzVM -Name testing-ubuntu -ResourceGroupName franchutes
#
Get-AzNetworkInterface -ResourceGroupName franchutes | Remove-AzNetworkInterface -Force
# Remove-AzDisk -Force -ResourceGroupName franchutes -DiskName <DiskName>
# Remove-AzDisk -Force -ResourceGroupName franchutes -DiskName $vm.StorageProfile.OSDisk.Name -> To delete the disk from the vm before installed
Get-AzDisk -ResourceGroupName franchutes | Remove-AzDisk -Force
# Remove-AzVirtualNetwork -Force -ResourceGroupName franchutes -Name <VirtualNetworkName>
Get-AzVirtualNetwork -ResourceGroupName franchutes | Remove-AzVirtualNetwork -Force
Get-AzNetworkSecurityGroup -ResourceGroupName franchutes | Remove-AzNetworkSecurityGroup -Force
Get-AzPublicIpAddress -ResourceGroupName franchutes | Remove-AzPublicIpAddress -Force