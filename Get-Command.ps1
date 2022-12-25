Get-Process | Get-Member -MemberType All

# Get-Process is a System.Diagnostics.Process
Get-Command -ParameterType Process | Format-Table

Get-Process -Name 'Teams' | Get-Member -MemberType Methods | Select-Object Name, MemberType