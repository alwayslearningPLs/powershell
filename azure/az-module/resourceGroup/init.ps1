
# Get the name of all locations available
Get-AzLocation | Select-Object Location
Get-AzLocation | Where-Object GeographyGroup -like 'Europe' | Select-Object Location,Providers | Sort-Object -Descending -Property Location

New-AzResourceGroup -Name franchutes -Location francecentral

# /subscriptions/<subscription-id>/resourceGroups/<GroupResourceName>
If ((Get-AzResourceGroup -Location francecentral).ResourceId -match '/subscriptions/' + (Get-AzContext).Subscription + '/resourceGroups/' + (Get-AzResourceGroup -Location francecentral).ResourceGroupName) {
  Write-Host "The ResourceId matches the expected format" -ForegroundColor Green
}

# Creating and removing a Azure Resource Group
New-AzResourceGroup -Name norway -Location norwayeast
Remove-AzResourceGroup -Name norway

# Creating an Azure resource group using tags
New-AzResourceGroup -Name europe -Location westeurope -Tag @{env="des"; partOf="path_to_norway"; purpose="just_learning"} -Force
Get-AzResourceGroup -ResourceGroupName europe -Location westeurope

Get-AzLocation | Where-Object GeographyGroup -like 'Europe' | Select-Object Location | Select-String europe

Get-Help -Name New-AzResourceGroup -Parameter Tag
