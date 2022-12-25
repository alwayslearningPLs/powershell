Param (
  [Parameter(Mandatory)]
  [int]$FirstNumber,
  [Parameter(Mandatory)]
  [int]$SecondNumber
)

if ($FirstNumber -le 0 -or -not $SecondNumber -gt 0) {
  Write-Error -Message "Don't introduce any number less than 0" -Category InvalidArgument -ErrorAction Stop
}

Write-Host "$FirstNumber + $SecondNumber = $($FirstNumber + $SecondNumber)" -ForegroundColor green
