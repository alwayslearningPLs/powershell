# - Local jobs.
# - Windows Powershell jobs.
# - Common Information Model (CIM)/Windows Management Instrumentation (WMI) jobs.

Get-Help -Name Get-Service

# local jobs
Get-Service -Name Dhcp | Where-Object Status -like 'Running'

# Job Ids might not seem to be sequential
Start-Job -ScriptBlock { Write-Host "Hello world" } -Name Greeting
Get-Job -Name Greeting
Wait-Job -Name Greeting -Timeout 10
Remove-Job -Name Greeting

Set-Content -Path .\testing.ps1 -Value @"
Write-Output "Hello! I'm being executed from a file"

For (`$i = 0; `$i -lt 10; `$i++) {
  Start-Sleep -Seconds 1
  Write-Output "This is my number `$i"
}
"@
Start-Job -FilePath .\testing.ps1 -Name GreetingFromFile

# Waiting and gathering information
Get-Job -Name GreetingFromFile
Wait-Job -Name GreetingFromFile -Timeout 10
Receive-Job -Name GreetingFromFile

# Removing
Remove-Item -Path .\testing.ps1
Remove-Job -Name GreetingFromFile

# Remote jobs