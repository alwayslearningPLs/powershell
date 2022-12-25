# Connecting to Azure Cloud
# https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-9.2.0

# 1. We can access to Azure Cloud in an interactive manner.
# Connect-AzAccount
# Disconnect-AzAccount

# 2. This example only works when the user doesn't have a double factor authenticator.
$credentials = Get-Credential -Message "Credentials to authenticate in Azure Cloud" -Title "Azure Cloud"
Connect-AzAccount -Credential

# Get-AzContext
# Set-AzContext -Subscription '00000000-0000-0000-0000-000000000000' (Get-AzContext | Select-Object Subscription)