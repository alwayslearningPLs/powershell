# Get-Verb, Get-Command, Get-Help, Get-Member
#
# Gives all the information about powershell installation
$PSVersionTable

# PSVersionTable is a like a HashMap
# TypeName: System.Management.Automation.PSVersionHashTable

$PSVersionTable.GetType()

$PSVersionTable.Keys

# We are iterating over each key inside the HashTable and getting the key and value in that key
$PSVersionTable.Keys | ForEach-Object {
  $_, $PSVersionTable.Item($_)
}

# Display Major, minor and patch version of the powershell
$PSVersionTable.PSVersion | Select-Object Major, Minor, Patch | Format-List

# Get all the command-lets or cmdlets available on the Powershell
Get-Verb | ForEach-Object {
  $_.Verb
}

# Get more information or go directly to the command let
Get-Command -Name Add-Content
Get-Command -Verb Add
Get-Command -Noun Member
Get-Command -Verb Get -Noun Member
Get-Command -Verb Get -Noun Win*

# To get Help about command lets
Get-Help -Name Add-Content

# Both commands are the same
$PSVersionTable | Get-Member -MemberType Property
Get-Member -InputObject $PSVersionTable -MemberType Property

# Stuff about files
Get-FileHash -Path .\example.ps1 -Algorithm SHA256 | Format-List
Get-FileHash -Path .\example.ps1 -Algorithm SHA384 | Format-Table
Get-FileHash -Path .\example.ps1 -Algorithm SHA384 | Format-Wide Hash

Get-Process -Name 'teams' | Sort-Object -Descending -Property CPU
Get-Process -Name 'teams' | Sort-Object -Descending -Property CPU, WS
Get-Process -Name 'teams' | Sort-Object -Property @{ Expression = "CPU"; Descending = $True }, @{ Expression = "WS"; Descending = $False }

Get-Process -Name 'teams' | Where-Object WS -gt 90 | Sort-Object -Descending -Property CPU | Select-Object -First 1

# To update help documentation, use: Update-Help -UICulture en-US

# To create a new file use: 'New-Item filename.ps1' and after that use 'code filename.ps1' to open it in visual studio code

Write-Output "Hello world!".ToLower()
"Hello world"