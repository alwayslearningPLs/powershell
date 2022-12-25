#!/bin/bash
#
# Deploying a simple webapp with PHP code
group=testing
location=$(az account list-locations --output json --query "[?name=='centralus'].name | [0]" | jq -r .)
azurePlan=php-webapp
azureWebApp=sasdfasdfasdf

# az group list --output json | jq '.[] | select(.name=="testing" && .location=="centralus")'
if [[ $(az group list --query "length([?name=='testing' && location=='centralus'])") -eq 0 ]]; then
  echo "We are going to create the ResourceGroup $group with Location $location"
  az group create --name $group --location $location --tags "managed-by=me" "env=dev"
fi

if [[ $(az appservice plan list --query "length([?name=='php-webapp'])" --output json) -eq 0 ]]; then
  echo "We are going to create the appzervice plan for the group $group, location $location and sku B1"
  az appservice plan create --name $azurePlan --resource-group $group --location $location --sku B1
fi

if [[ $(az webapp list --query "length([?name=='sasdfasdfasdf'])") -eq 0 ]]; then
  echo "We are going to create the webapp for the group $group and plan $azurePlan"
  az webapp create --name $azureWebApp --resource-group $group --plan $azurePlan
fi

curl http://$(az webapp list --query "[?name=='sasdfasdfasdf'].defaultHostName | [0]" --output json | jq -r .)

az webapp deployment source config --name 'sasdfasdfasdf' --resource-group $group --repo-url https://github.com/Azure-Samples/php-docs-hello-world --branch master --manual-integration

curl http://$(az webapp list --query "[?name=='sasdfasdfasdf'].defaultHostName | [0]" --output json | jq -r .)
