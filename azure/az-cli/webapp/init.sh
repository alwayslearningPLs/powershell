#!/bin/bash

# List all the runtimes available to deploy webapps.
az webapp list-runtimes --os-type linux

# Each app service plan defines:
# - Region (West US, East US, etc.).
# - Number of VM instances.
# - Size of VM instances (Small, Medium, Large).
# - Pricing tier (Free, Shared, Basic, Standard, Premium, PremiumV2, PremiumV3, Isolated, IsolatedV2).
#   + Shared compute (Free and Shared).
#   + Dedicated compute (Basic, Standard, Premium, PremiumV2, PremiumV3).
#   + Isolated -> Azure VMs run on dedicated Azure Virtual Networks.
#   + Consumption -> This tier is only available to function apps. It scales the funtion dynamically depending on workload.
#
# Deploy to App Service
#
# Automated deployment -> Azure DevOps, GitHub and Bitbucket.
# Manual deployment -> Git, CLI, Zip deploy, FTP/S
