# cmdlets: Get-Variable, Set-Variable, Clear-Variable and New-Variable
# Returns all the variables on the session
Get-Variable

# Displays Name and Value
Get-Variable -Name PWD

# Displays Only the value
Get-Variable -Name PWD -ValueOnly

# Powershell allows spaces in variable names.
# Variable names are not case sensitive.
# It's common so capitalize the first letter of a variable name.
[int] $first = 1
$Second = 2
[int] ${This is the third} = 3
${This is the fourth} = 4
Set-Variable -Name Fifth -Value 5 -Scope Script
Set-Variable -Name 'This is the Sixth' -Value 6 -Scope Script

Write-Host "$FIRST $Second ${This is the Third} ${This is the fourth} $(Get-Variable -Name Fifth -Scope Script -ValueOnly) $(Get-Variable -Name 'This is the Sixth' -Scope Script -ValueOnly)" -ForegroundColor Green

# When Placing the variable name between double quotes ("), the content of that variable is displayed. 
Write-Host "$first and '$first' and `$first" + '$first'

# How to clear a variable?
$first = $null
Clear-Variable -Name Second -Scope Script

Write-Host "Value of first $first and value of second $second"

# Creating a constant variable
New-Variable -Name PI `
  -Value 3.14 `
  -Description "The value of PI" `
  -Scope Script `
  -Option Constant `
  -Visibility Public `
  -Force

[String] $Str = "Hello world"
[Int] $Number = "2" # or 2
[DateTime] $Now = Get-Date -Format 'yyyy-MM-dd'
[Double] $DoubleValue = 2.4
[Bool] $SwitchVariable = $True

Write-Host "$($str.GetType()): $Str, $($Number.GetType()): $Number, $($Now.GetType()): $Now, $($DoubleValue.GetType()): $DoubleValue, $($SwitchVariable.GetType()): $SwitchVariable" -ForegroundColor Green

# Type of variables: String, Int, Double, DateTime, Bool
# Option values can be: None, ReadOnly, Constant, Private, AllScope, Unspecified
# Visibility: Public or Private
