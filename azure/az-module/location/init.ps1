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

$Location = Get-AzLocationNearest

Write-Host -ForegroundColor Green -Message "This is my nearest location: $Location"