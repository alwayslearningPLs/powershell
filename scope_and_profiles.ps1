# There is different scopes to be aware of:
#   - Global: It is the powershell terminal session
#   - Script: Is is the file execution. We can create a global variable using the global keyword
#   - local: The current scope

global $var = 1

# All users, all hosts 	$PSHOME\Profile.ps1
# All users, current host 	$PSHOME\Microsoft.PowerShell_profile.ps1
# Current user, all hosts 	$Home[My ]Documents\PowerShell\Profile.ps1
# Current user, current host 	$Home[My ]Documents\PowerShell\Microsoft.PowerShell_profile.ps1

$PSHOME
$HOME
$Profile

$Profile | Select-Object *

$Profile.CurrentUserCurrentHost

# How to create a new profile?
New-Item -Path $Profile.CurrentUserCurrentHost -ItemType "file"

Add-Content -Encoding UTF8 -Path $Profile.CurrentUserCurrentHost -Value 'Write-Output "Hello world!"'

Get-Content -Path $Profile.CurrentUserCurrentHost

Remove-Item -Path $Profile.CurrentUserCurrentHost
# Stops here

New-Item -Path $Profile.CurrentUserCurrentHost `
  -ItemType "file" `
  -Force `
  -Value 'Write-Host "Hello Ivan, Welcome Back" -foregroundcolor Green'