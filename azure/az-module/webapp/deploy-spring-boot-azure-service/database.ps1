# SSL certificate issue -> https://learn.microsoft.com/en-us/azure/mysql/single-server/concepts-certificate-rotation#create-a-combined-ca-certificate
# Migration from MySqlServer single instance to MySqlFlexibleServer -> https://learn.microsoft.com/en-us/azure/mysql/single-server/whats-happening-to-mysql-single-server
Param (
  [string] $DatabaseName = "mysql-server-$(-join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ }))"
)

# It will return westeurope (I'm doing this pipeline just to practice them, not a real scenario)
$Location           = (Get-AzLocation | Where-Object { $_.GeographyGroup -like 'Europe' -and $_.RegionCategory -like 'Recommended' -and $_.RegionType -like 'Physical' } | Sort-Object -Top 1 -Unique -Descending -Property Location).Location
$ResourceGroupName  = 'test-ivan'
$MySQLUser          = 'MrTimeout'
$MySQLSecurePass    =  ConvertTo-SecureString -String 'Thisisnotmyrealpassword69' -AsPlainText -Force
$LocalIpAddress     = (Invoke-WebRequest -Method Get -Headers @{'Accept' = 'text/plain';} -Uri 'http://whatismyip.akamai.com/' | Where-Object { $_.StatusCode -eq 200 -and $_.Content -match '(\d{1,3}\.){3}\d{1,3}' }).Content

Try {
  Get-AzResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location -ErrorAction Stop
} Catch {
  Write-Host "Creating the Azure Resource Group with Name $ResourceGroupName, Location $Location" -ForegroundColor Green
  New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force -Tag @{ purpose = 'testing'; activities = 'deploy spring boot azure lab' }
}

Try {
  # Single Server instance is going to be retired by September 16, 2024. We should migrate to AzMySqlFlexibleServer
  Get-AzMySqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName -ErrorAction Stop
} Catch {
  Write-Host -Message "Creating the Azure DB MySQL with Name $DatabaseName" -ForegroundColor Green
  # More information about Azure DDBB tiers
  # Sku is typically 'tier + family + cores'
  # If you need to register this resource provider, go to Resource Provider menu inside your subscription and look for Microsoft.DBforMySQL
  # You can also execute this command: Register-AzResourceProvider -ProviderNamespace Microsoft.DBforMySQL
  New-AzMySqlServer -ResourceGroupName $ResourceGroupName `
    -Name $DatabaseName `
    -Location $Location `
    -AdministratorUserName $MySQLUser `
    -AdministratorLoginPassword $MySQLSecurePass `
    -StorageInMb 5120 `
    -Sku B_Gen5_1 `
    -Version '8.0' `
    -BackupRetentionDay 7 `
    -GeoRedundantBackup Disabled `
    -SslEnforcement Enabled
  # DatabaseName -> It can only contain from 3-63 characters, lowercase, numbers and hypen (-)
  # StorageInMb -> Minimun value is 5120MB and it goes up adding 1024 MB each time
  # BackupRetentionDay (from 7 to 35) -> How long a backup should be retained. Unit is days.
  # GeoRedundantBackup (Only for non-basic tier) -> It cannot be changed after creation of the resource
  # Tiers: B (Basic), GP (General Purpose), MO (Memory Optimized)
  # The server name must be unique, because it maps to a DNS name in Azure.

  # Disable ssl by the moment, just for testing purposes
  Update-AzMySqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName -SslEnforcement Disabled
}

foreach ($rule in @{ "$DatabaseName-database-allow-local-ip" = "$LocalIpAddress"; "$DatabaseName-all-azure-IPs" = '0.0.0.0' }.GetEnumerator()) {
  Try {
    Get-AzMySqlFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $DatabaseName -Name $rule.Key -ErrorAction Stop
  } Catch {
    Write-Host "Adding new MySQL Firewall rule with name $($rule.Key) and IP $($rule.Value)" -ForegroundColor Green
    New-AzMySqlFirewallRule -ResourceGroupName $ResourceGroupName `
      -Name $rule.Key `
      -ServerName "$DatabaseName" `
      -StartIPAddress $rule.Value `
      -EndIPAddress $rule.Value
  }
}

# $DatabaseName.mysql.database.azure.com
$MySQLDomainName = (Get-AzMySqlServer -ResourceGroupName $ResourceGroupName -Name $DatabaseName).FullyQualifiedDomainName

$Uri = "$($MySQLUser)%40$($DatabaseName)@$($MySQLDomainName):3306"
Write-Host -ForegroundColor Green -Message "If you want to connect to the MySQL instance, use: $Uri"

mysqlsh $Uri `
  --password="$(ConvertFrom-SecureString -SecureString $MySQLSecurePass -AsPlainText)" `
  --sql `
  --execute="CREATE DATABASE IF NOT EXISTS tasks"

Get-AzMySqlServer -ResourceGroupName 'test-ivan' | Select-Object Name, FullyQualifiedDomainName
