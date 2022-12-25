Param (
  [Parameter(Mandatory, HelpMessage="Number must be provided")]
  [int] $FirstNumber,
  [Parameter(Mandatory, HelpMessage="Number must be provided")]
  [int] $SecondNumber
)

Write-Host "$FirstNumber + $SecondNumber = $($FirstNumber + $SecondNumber)" -ForegroundColor Blue