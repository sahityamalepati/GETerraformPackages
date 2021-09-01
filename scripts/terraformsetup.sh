layerName=$1
environment=$2
backendResourceGroupName=$3
backendStorageAccountName=$4
backendContainername=$5
buildRepositoryName=$6
basedOnStratumKitName=$7
layerType=$8
layerDestroy=$9
kitPath=${10}
provider=${11}
inputFile=${12}

if [ -z "$kitPath" ]
then
      kitPath="."
fi

echo "layerName:" $layerName
echo "environment:" $environment
echo "backendResourceGroupName:" $backendResourceGroupName
echo "backendStorageAccountName:" $backendStorageAccountName
echo "backendContainername:" $backendContainername
echo "buildRepositoryName:" $buildRepositoryName
echo "basedOnStratumKitName:" $basedOnStratumKitName
echo "layerType:" $layerType
echo "layerDestroy:" $layerDestroy
echo "kithPath:" $kitPath
echo "provider:" $provider
echo "inputFile:" $inputFile

if [[ $buildRepositoryName = "Stratum" ]];
then
    echo "Working directory kits/$basedOnStratumKitName because running from Stratum"
    kitPath="kits/$basedOnStratumKitName"
fi

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
export ARM_USE_MSI=true

set +e

if [[ $(az group exists -n $backendResourceGroupName -o tsv) = false ]];
then
    echo "$backendResourceGroupName RG was not found. Please ensure the base infrastructure pipeline ran successfully and try again"
    exit -1
else
    echo "Using resource group $backendResourceGroupName"
fi
az storage account show -n $backendStorageAccountName -g $backendResourceGroupName &> /dev/null
set -e
if [[ $? -eq 0 ]];
then
    echo "Using storage account $backendStorageAccountName in resource group $backendResourceGroupName"
else
    echo "$backendStorageAccountName storage account in resource group $backendResourceGroupName was not found."
    exit -1
fi
az storage container create --name $backendContainername --account-name $backendStorageAccountName 