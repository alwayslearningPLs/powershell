Param(
  [Parameter(Mandatory, HelpMessage="Name of the disk that you want to create")]
  [String] $DiskName,
  [Parameter(Mandatory, HelpMessage="Action that you want to execute on the Disk")]
  [ValidateSet('New', 'Remove', 'Update')]
  [String] $Action,
  [Parameter(HelpMessage="Size of the disk in GiB")]
  [ValidateRange(4, 32)]
  [Int] $DiskSize
)

$DiskExists = $True
$ResourceGroupName = 'franchutes'

Get-AzResourceGroup -ResourceGroupName $ResourceGroupName -ErrorAction Stop

Try {
  Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName -ErrorAction Stop
} Catch {
  If ($_.Exception.Message -ilike '*was not found*') {
    Write-Host "The resource doesn't exists" -ForegroundColor Red
    $DiskExists = $False
  } Else {
    Throw $_
  }
}

If ($Action -like 'New' -and -not $DiskExists) {
  Write-Host "Creating the disk" -ForegroundColor Green
  $DiskConfig = New-AzDiskConfig -Location (Get-AzResourceGroup -ResourceGroupName $ResourceGroupName).Location `
    -SkuName Standard_LRS `
    -DiskSizeGB 4 `
    -CreateOption Empty

  New-AzDisk `
    -ResourceGroupName $ResourceGroupName `
    -DiskName $DiskName `
    -Disk $DiskConfig
} ElseIf ($Action -like 'Remove' -and $DiskExists) {
  Write-Host "Removing the Disk with name: $DiskName" -ForegroundColor Green
  Remove-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName -Force
} ElseIf ($Action -like 'Update' -and $DiskExists) {
  Write-Host "We are going to check if the size entered is not equal to the actual size of the managed disk" -ForegroundColor Yellow
  If ((Get-AzDisk -ResourceGroupName $ResourceGroupName -DiskName $DiskName).DiskSizeGB -eq $DiskSize) {
    Write-Host "The input size and the actual size of the disk are equal, we are not going to update nothing" -ForegroundColor Red
  } Else {
    Write-Host "We are going to update the size of the disk to $DiskSize" -ForegroundColor Green
    New-AzDiskUpdateConfig -DiskSizeGB $DiskSize | Update-AzDisk -ResourceGroupName $ResourceGroupname -DiskName $DiskName
  }
}
