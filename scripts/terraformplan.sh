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
planOnly=${13}

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
echo "planOnly:" $planOnly

if [[ $buildRepositoryName == "GETerraformPackages" ]];
then
    echo "Working directory kits/$basedOnStratumKitName because running from GETerraformPackages"
    kitPath="kits/$basedOnStratumKitName"
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
  echo "creating resource_ids.tf for Private Endpoints"
  chmod +x pe.sh 2> /dev/null
  ./pe.sh 2> /dev/null
  cat resource_ids.tf
fi

if [[ $layerType == "azuremonitor" ]];
then
  echo "creating resource_ids.tf for Azure Monitor"
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

if [[ $layerDestroy == "False" ]];
then
  echo "Terraform Plan"
  terraform plan -out $environment-$layerType-layer.tfplan -input=false \
  -var="subscription_id=$ARM_SUBSCRIPTION_ID" \
  -var="tenant_id=$tenantId" -detailed-exitcode
  # -var="client_id=$servicePrincipalId" \
  # -var="client_secret=$servicePrincipalKey" \


  detailedExitCode=$?
  echo "Destroy False detailedExitCode:" $detailedExitCode
fi

if [[ $layerDestroy == "True" ]];
then
  echo "Terraform Plan Destroy"
  terraform plan -destroy \
  -var="subscription_id=$ARM_SUBSCRIPTION_ID" \
  -var="tenant_id=$tenantId" -detailed-exitcode
  # -var="client_id=$servicePrincipalId" \
  # -var="client_secret=$servicePrincipalKey" \


  detailedExitCode=$?
  echo "Destroy True detailedExitCode:" $detailedExitCode
fi

# Check if there are any change to apply and skip if none
# Create a skip.txt artifact with true/false to be passed to apply stage
# If Azure Pipelines supports cross-stage variables in the future, the
# artifact can be replaced by just using a variable
if [[ $detailedExitCode = 0 ]];
then
  echo "No changes detected by Terraform. Skipping apply"
  echo True > $BUILD_ARTIFACTSTAGINGDIRECTORY/skip.txt
elif [[ $detailedExitCode = 1 && $planOnly == "false" ]];
then
  echo "Error detected by Terraform. Breaking build"
  exit 1
elif [[ $planOnly == "true" ]];
then
  echo "planOnly is set to true. Skipping apply"
  echo True > $BUILD_ARTIFACTSTAGINGDIRECTORY/skip.txt
else
  echo "Changes detected by Terraform. Continuing with apply"
  echo False > $BUILD_ARTIFACTSTAGINGDIRECTORY/skip.txt
fi
