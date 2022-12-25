
$IntArray = 1,2,3,4,5,6
$StringArray = @("hello", "bye")

$NearlyEmptyArray = ,1
[array] $NearlyEmptyArray2 = "hello"
$EmptyArray = @()

[int[]] $StronglyTypedArray = @(1, 2, 3, 4)

# Looping
$IntArray | % { Write-Host $($_ * 2) }

$StringArray | ForEach-Object { Write-Host "$_ Pedro" }

foreach($Each in $StronglyTypedArray) {
  Write-Host "Next value is $Each" -ForegroundColor Green
}

For ($i = 0; $i -lt $IntArray.Length; $i++) {
  Write-Host "Next value is $($IntArray[$i])" -ForegroundColor Green
}

# How to add numbers to an array
$NearlyEmptyArray += 2
$NearlyEmptyArray = $NearlyEmptyArray + 3

# Showing some types
Write-Host "$($IntArray.GetType()) and $($StronglyTypedArray.GetType())"

Write-Host "$NearlyEmptyArray, $NearlyEmptyArray2 and $EmptyArray"

## Arrays are cool! In powershell, arrays are fixed size, so we need to recreate them every time we add a new value
## and there is not formal way to remove an item. In this type of cases, we should use a System.Collections.ArrayList
[System.Collections.ArrayList] $Pokemons = @("Pikachu", "Bulbasur")
$EmptyArrayList = New-Object System.Collections.ArrayList

$Pokemons.Add("Charizard")
$Pokemons.Add("NotExistent")
$Pokemons.Remove("NotExistent")

Write-Host "Pokemons: $Pokemons and $EmptyArrayList"

## A little about HashTables
$Servers = @{ "Omega" = "192.168.1.10"; "Alfa" = "192.168.1.11"; "Next-Alfa" = "192.168.1.12" }

Write-Host "$($Servers.Omega) $($Servers['Next-Alfa']) $($Servers.'Next-Alfa')"