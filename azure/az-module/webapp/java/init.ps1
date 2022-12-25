
$ResourceGroupName = 'europe'
$AppServicePlanName = 'my-webapp'
$Location = ((Get-AzLocation | Where-Object { $_.RegionCategory -like 'Recommended' -and $_.RegionType -like 'Physical' -and $_.GeographyGroup -like 'Europe' } | Sort-Object -Descending -Property Location -Unique | Select-Object -First 1 -Property Location).Location)

Try {
  Get-AzResourceGroup -ResourceGroupName $ResourceGroupName -ErrorAction Stop
} Catch {
  New-AzResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location -Tag @{ env = "pre"; purpose = "testing" }
}

New-AzAppServicePlan -ResourceGroupName $ResourceGroupName `
  -Location $Location `
  -Linux `
  -Tier 'Basic' `
  -NumberOfWorkers 1 `
  -WorkerSize 'Small' `
  -Name $AppServicePlanName

New-AzWebApp -ResourceGroupName $ResourceGroupName `
  -Name "$($AppServicePlanName)-java" `
  -AppServicePlan $AppServicePlanName

Get-AzWebApp -ResourceGroupName europe -Name my-webapp-java | Get-Member -MemberType Property

Get-Command -Verb Get -Noun *WebApp*

# You need to execute this command to add the azure webapp dependency to maven project
# mvn com.microsoft.azure:azure-webapp-maven-plugin:1.12.0:config