#!/bin/bash

resourceGroupName='pre-env'

# How to list locations
az account list-locations --query '.[].{geographyGroup:metadata.geographyGroup, name: name}' --output table

az group create --name 'pre-env' --location 'francecentral'

az group list --output table

az group list --query "[?name == '$resourceGroupName']"
