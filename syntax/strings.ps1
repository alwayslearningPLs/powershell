

# Modifying case of string
'hello world'.ToUpper()
'hello world'.ToUpper("en-US")

'HELLO WORLD'.ToLower()
'HELLO WORLD'.ToLower("en-US")

# Some properties
'hello world'.length

$a = 'Hello world!'
$b = 1
# Single-Quotes don't allow us to print the value of the variable a
Write-Output 'This is my message to you: $a'
# Double-Quotes allows us to print the value of the variable and also escape the dolar sign
Write-Output "This is my message to you: `"$a`" and `$a"
Write-Output "This is my message to you: $(Get-Date) and $($b + 1)"

[string] $str = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroupName/providers/Microsoft.Network/networkSecurityGroups/networkSecurityGroupName'
If (-not $str.Contains("networkSecurityGroups")) {
  Write-Error "This `"NetworkSecurityGroup`" is not a NetworkSecurityGroup" -ErrorAction Stop
}

$str.Substring($str.LastIndexOf('/') + 1)

[string] $str = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroupName/providers/Microsoft.Network/virtualNetworks/virtualNetworkName/subnets/subnetName'
$str.Split('/')[8]