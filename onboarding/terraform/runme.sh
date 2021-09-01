#!/bin/bash
echo "starting onboarding services deployment"

appid=$(awk '/appid/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
region=$(awk '/region/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
vnet_rg_name=$(awk '/vnet_rg_name/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
vnet_name=$(awk '/vnet_name/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
subnet_name=$(awk '/subnet_name/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
subnet_prefix=$(awk '/subnet_prefix/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
backendResourceGroupName=$appid-$region-devops-rg
backendStorageAccountName="${appid}devopsstdgge"
nsg_name="nsg-devops"
backendContainerName="devops"
ARM_SUBSCRIPTION_ID=$(awk '/subscription_id/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
userID=$(awk '/userID/ {print $3;}' terraform.tfvars | tr -d '"' | tr -d '\040\011\012\015')
created=$(date +"%d %b %Y %R %Z" -u)

az account show 1> /dev/null
if [ $? != 0 ]; then
  az login
fi

if [[ $(az account show --query id | tr -d '"') != $ARM_SUBSCRIPTION_ID ]]; then
    az account set --subscription $ARM_SUBSCRIPTION_ID
fi

if [[ $(az group exists -n $backendResourceGroupName -o tsv) = false ]]; then
    echo "Creating resource group $backendResourceGroupName"
    az group create -l $region -n $backendResourceGroupName --tags 'created_by'=${userID} 'appid'=${appid} 'created'="${created}" 'last_modified'="${created}" 'environment=nprd' 'automated_by=ge-onboarding-devops-services'
else
    echo "Using resource group $backendResourceGroupName"
fi
az storage account show -n $backendStorageAccountName -g $backendResourceGroupName &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "Using storage account $backendStorageAccountName in resource group $backendResourceGroupName"
else
    echo "Creating storage account $backendStorageAccoutName"
    az storage account create -n $backendStorageAccountName -g $backendResourceGroupName -l $region --sku Standard_LRS --assign-identity --tags 'created_by'=${userID} 'appid'=${appid} 'created'="${created}" 'last_modified'="${created}" 'environment=nprd' 'automated_by=ge-onboarding-devops-services'
    az storage blob service-properties delete-policy update --days-retained 30  --account-name $backendStorageAccountName --enable true &> /dev/null
fi

az storage account update --default-action Allow --name $backendStorageAccountName --resource-group $backendResourceGroupName
echo "Updating storage account network rules"
# This gives time for the storage account rules to update so the container creation step does not fail
sleep 15
user_id=$(az ad signed-in-user show --query "objectId")
sa_principal_id=$(az storage account show --name $backendStorageAccountName --resource-group $backendResourceGroupName --query identity.principalId --output tsv)
az storage account update --name $backendStorageAccountName --resource-group $backendResourceGroupName --min-tls-version TLS1_2
az storage container create --name $backendContainerName --account-name $backendStorageAccountName

set -e
az network nsg create --name $nsg_name --resource-group $backendResourceGroupName --location $region
nsg_id=$(az network nsg show --name $nsg_name --resource-group $backendResourceGroupName --query id --output tsv)
az network vnet subnet create --resource-group $vnet_rg_name --vnet-name $vnet_name --name $subnet_name --address-prefixes $subnet_prefix --network-security-group $nsg_id --route-table "rt-Private"

terraform init -input=false \
-backend-config="resource_group_name=$backendResourceGroupName" \
-backend-config="storage_account_name=$backendStorageAccountName" \
-backend-config="container_name=$backendContainerName" \
-backend-config="key=terraform.tfstate" \
-backend-config="subscription_id=$ARM_SUBSCRIPTION_ID"

terraform apply \
  -var="subscription_id=$ARM_SUBSCRIPTION_ID" \
  -var="user_id=$user_id" \
  -var="sa_principal_id=$sa_principal_id" 