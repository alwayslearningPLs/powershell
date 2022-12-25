If (Test-Path -Path $env:windir\System32\WindowsPowershell\v1.0) {
  Write-Host "The path $($env:windir)\System32\WindowsPowershell\v1.0, where powershell 5.1 is installed, exists" -ForegroundColor Green
}

If (Test-Path -Path $env:ProgramFiles\PowerShell\7) {
  Write-Host "The path $($env:ProgramFiles)\PowerShell\7, where Powershell version 7 is installed, exists" -ForegroundColor Green
}

# In version 5, the name of the executale is powershell.exe
Test-Path $env:windir\System32\WindowsPowershell\v1.0\powershell.exe
# In version 6, the name of the executable is pwsh.exe
Test-Path $env:ProgramFiles\Powershell\7\pwsh.exe

# Displays all the path modules, printing them in green if they exist, and red if not.
($env:PSModulePath).Split(';') | ForEach-Object { Write-Host -ForegroundColor ((Test-Path $_) ? 'Green' : 'Red' ) -Message $_ }

# Separate profiles for each version
Write-Host "This is the path to execute powershell scripts when starting a fresh session in powershell 5.1: $HOME\Documents\WindowsPowerShell"
Write-Host "This is the path to execute powershell scripts when starting a fresh session in powershell 7: $HOME\Documents\PowerShell"

Write-Host "Remember to use `$PSVersionTable to know which version you are running. Example: $($PSVersionTable.PSVersion)"
$PSVersionTable

## Execution policy
Get-ExecutionPolicy

# Settings
# - AllSigned: Limit scripts execution to all signed scripts.
# - Default: Restricted for windows clients and RemoteSigned for Windows servers.
# - RemoteSigned
# - Restricted: Allows running commands, but not scripts.
# - Unrestricted: Default policy for non-windowws computers
# - Undefined: No execution policy set in the current scope.

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Powershell have a lot of alias
Get-Alias

# Will open a PowerShell window and it shows every allowed parameter.
Show-Command Get-ChildItem

# Really useful
Get-Help -Name Get-ChildItem -ShowWindow