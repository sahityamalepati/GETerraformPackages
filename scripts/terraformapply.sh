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

# touch to get fresh layer versions for use with MSI

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

if [[ $buildRepositoryName == "GETerraformPackages" ]];
then
    echo "Working directory kits/$basedOnStratumKitName because running from GETerraformPackages"
    kitPath="kits/$basedOnStratumKitName/"
fi

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
export ARM_USE_MSI=true

echo "Move layer TF variables to layer source"
mv $kitPath/Layers/$environment/var-$layerName.tf ./layer-$layerType
mv $kitPath/Layers/$environment/var-$layerName.auto.tfvars ./layer-$layerType
mv $kitPath/Layers/$environment/var-$layerName-dependencies.tf ./layer-$layerType
mv $kitPath/Layers/$environment/$layerName.* ./layer-$layerType
mv $kitPath/Layers/$environment/$inputFile ./layer-$layerType

# For vm, vmss cloud inits or custom script extensions
if [[ -d "$kitPath/Layers/scripts" ]];
then
  echo "$kitPath/Layers/scripts exists on your filesystem."
  ls $kitPath/Layers/scripts

  #TODO - allow param for where the user wants to place this
  cp $kitPath/Layers/scripts/* ./layer-$layerType
fi

cd ./layer-$layerType
ls -Flah

if [[ $layerType == "privateendpoints" || $layerType == "adoprivateendpoints" ]];
then
  chmod +x pe.sh 2> /dev/null
  ./pe.sh 2> /dev/null
  cat resource_ids.tf
fi

if [[ $layerType == "azuremonitor" ]];
then
  chmod +x monitor.sh 2> /dev/null
  ./monitor.sh 2> /dev/null
  cat resource_ids.tf
fi

if [[ $layerType == "trafficmanager" ]];
then
  echo "creating resource_ids.tf for Azure Traffic Manager"
  chmod +x trafficmanager.sh 2> /dev/null
  ./trafficmanager.sh 2> /dev/null
  cat resource_ids.tf
fi

echo "Terraform Init"
terraform init -input=false \
-backend-config="resource_group_name=$backendResourceGroupName" \
-backend-config="storage_account_name=$backendStorageAccountName" \
-backend-config="container_name=$backendContainername" \
-backend-config="key=$layerName.tfstate" \
-backend-config="subscription_id=$ARM_SUBSCRIPTION_ID" \
-backend-config="tenant_id=$tenantId"
#-backend-config="client_id=$servicePrincipalId" \
#-backend-config="client_secret=$servicePrincipalKey"

terraform workspace new $environment 2> /dev/null
terraform workspace select $environment


pwd
ls -Flah

set -e

if [[ $layerDestroy == "False" ]];
then
  echo "Terraform Apply"
  terraform apply \
  -var="subscription_id=$ARM_SUBSCRIPTION_ID" \
  -var="tenant_id=$tenantId" -auto-approve 
  # -var="client_id=$servicePrincipalId" \
  # -var="client_secret=$servicePrincipalKey" \
fi

if [[ $layerDestroy == "True" ]];
then
  echo "Terraform Destroy"
  terraform destroy \
  -var="subscription_id=$ARM_SUBSCRIPTION_ID" \
  -var="tenant_id=$tenantId" -auto-approve 
  # -var="client_id=$servicePrincipalId" \
  # -var="client_secret=$servicePrincipalKey" \
fi
