#!/bin/bash

resourceGroupName='franchutes'
diskName='testing-disk'
location=$(az group show --name $resourceGroupName --query location --out tsv)

az disk create --resource-group $resourceGroupName --name $diskName --sku 'Standard_LRS' --size-gb 4

az disk show --resource-group $resourceGroupName --name $diskName

az disk update --resource-group $resourceGroupName --name $diskName --size-gb 8
