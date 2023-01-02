Param(
  [string]
  $DatabaseName = "postgresql-server-$(-join ((97..122) | Get-Random -Count 5 | ForEach-Object { [char]$_ }))"
)

function Get-LocationCurrent() {
  <#
  .SYNOPSIS
    Returns an object of type System.Device.Location.GeoCoordinateWatcher with your current location or throw an error.

  .DESCRIPTION
    Returns an object of type System.Device.Location.GeoCoordinateWatcher with your current location or throw an error.

  .OUTPUTS
    System.Device.Location.GeoCoordinateWatcher
  #>
  Add-Type -AssemblyName System.Device

  $GeoWatcher = New-Object -TypeName System.Device.Location.GeoCoordinateWatcher
  $GeoWatcher.Start()

  While ($GeoWatcher.Status -notin @('Ready', 'Denied')) {
    Start-Sleep -Milliseconds 100
  }

  If ($GeoWatcher.Status -eq 'Denied') {
    Write-Error -Message "error: You need to activate the Location of your device" -ErrorAction Stop
  }

  return $GeoWatcher.Position.Location
}

function Get-AzLocationNearest() {
  <#
  .SYNOPSIS
    Get the nearest azure location to your actual GPS position

  .DESCRIPTION 
    Get the nearest azure location to your actual GPS position

  .OUTPUTS
    string object representing the azure location name
  #>
  $Current    = Get-LocationCurrent
  $Locations  = @(Get-AzLocation | Where-Object { 
    $_.RegionType -eq "Physical" `
    -and $_.RegionCategory -eq "Recommended" `
  })

  $MinValue         = [decimal]::MaxValue
  $NearestPosition  = -1
  For($i = 0; $i -lt $Locations.Count; $i++) {
    $TargetLocationGPS=(New-Object -TypeName System.Device.Location.GeoCoordinate -ArgumentList $Locations[$i].Latitude,$Locations[$i].Longitude)
    $Distance=$Current.GetDistanceTo($TargetLocationGPS)
    If ($Distance -le $MinValue) {
      $MinValue = $Distance
      $NearestPosition = $i
    }
  }

  return $Locations[$NearestPosition].Location
}

$Location           = Get-AzLocationNearest
$ResourceGroupName  = 'test-ivan'
$UserName           = "mrtimeout"
$Password           = ConvertTo-SecureString -String "Thisisnotmypassword186*" -AsPlainText -Force
$MyIpAddress        = (Invoke-WebRequest -Method Get -Uri 'http://whatismyip.akamai.com/' -Headers @{ Accept = "text/html" } | Where-Object StatusCode -eq 200).Content

Try {
  Get-AzResourceGroup -Name $ResourceGroupName -Location $Location -ErrorAction Stop
} Catch {
  Write-Host -ForegroundColor Green -Message "Creating a new Azure resource group with name $ResourceGroupName"
  New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force -Tags @{env="pre"; azure_training="yes"; purpose="PostgreSQL Database"} -ErrorAction Stop
}

Register-AzResourceProvider -ProviderNamespace Microsoft.DBforPostgreSQL

Try {
  Get-AzPostgreSqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName -ErrorAction Stop
} Catch {
  Write-Host -ForegroundColor Green -Message "Creating the PostgreSQL server"
  New-AzPostgreSqlServer -ResourceGroupName $ResourceGroupName `
    -Location $Location `
    -Name $DatabaseName `
    -Sku B_Gen5_1 `
    -BackupRetentionDay 7 `
    -GeoRedundantBackup Disabled `
    -SslEnforcement Enabled `
    -StorageInMb 5120 `
    -Version "11.7" `
    -AdministratorUserName $Username `
    -AdministratorLoginPassword $Password

  Write-Host -ForegroundColor Green -Message "Creating firewall PostgreSQL Rule"
  New-AzPostgreSqlFirewallRule -Name AllowMyIP `
    -ResourceGroupName $ResourceGroupName `
    -ServerName $DatabaseName `
    -StartIPAddress $MyIpAddress `
    -EndIPAddress $MyIpAddress
}

Write-Host -ForegroundColor Green -Message "FullyQualifiedDomainName: " (Get-AzPostgreSqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName).FullyQualifiedDomainName