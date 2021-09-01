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

if [[ $buildRepositoryName = "GETerraformPackages" ]];
then
    echo "Working directory kits/$basedOnStratumKitName because running from GETerraformPackages"
    kitPath="kits/$basedOnStratumKitName/"
fi

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
export ARM_USE_MSI=true

IFS=$'\n' read -d '' -r -a lines < yamldependencies.txt
for line in "${lines[@]}"
do
    str=$(echo ${line// /,})    
    IFS=', ' read -r -a array <<< "$str"    
    
    replaceStr="s/data.terraform_remote_state.${array[1]}/data.terraform_remote_state.${array[2]}/g"
    sed -i $replaceStr ./layer-$layerType/main.tf
    sed -i $replaceStr ./layer-$layerType/providers.tf
done

dependencies=$(cat ./layer-$layerType/*.tf | grep -o "data.terraform_remote_state.*.outputs" | cut -d "." -f 3 | sort | uniq)
echo $dependencies

for dependency in $dependencies
do
    echo $dependency
    yamlDependency=($(grep -w $dependency yamldependencies.txt))
    # if layerNameYamlDependency is null set it to $dependency.  This could happen if a dependency is in main.tf
    # but the resource is not used.  ex: app gateway data lookup in vmss, but no app gateway needed
    if [[ -z "$yamlDependency" ]];
    then
        echo "No match found for yaml dependency"
        stateKey=$dependency
    else
        echo "$yamlDependency matched for yaml dependency ${yamlDependency[2]}"
        stateKey=${yamlDependency[2]}
    fi

    cat <<EOF >> $kitPath/Layers/$environment/var-$layerName-dependencies.tf
    data "terraform_remote_state" "$dependency" {
        backend = "azurerm"
        config = {
            resource_group_name  = "$backendResourceGroupName"
            storage_account_name = "$backendStorageAccountName"
            container_name       = "$backendContainername"
            key                  = "$stateKey.tfstateenv:$environment"
            subscription_id      = "$ARM_SUBSCRIPTION_ID"
            tenant_id            = "$tenantId"
            use_msi              = true
        }
    }
EOF

    # Run a TF Init on every data reference in the main.tf
    # This will initialize an empty state file for dependencies that 
    # may not be relevant for the deployment.
    # Example: VM has a data lookup for ASG, but your deployment may not have ASG
    # So an empty state file for ASG will stop it from crashing on plan refresh
    # terraform workspace new will create that file

    cd ./layer-$layerType/emptystate

    echo "Initialize state files if not exist"
    terraform init -input=false \
    -backend-config="resource_group_name=$backendResourceGroupName" \
    -backend-config="storage_account_name=$backendStorageAccountName" \
    -backend-config="container_name=$backendContainername" \
    -backend-config="key=$stateKey.tfstate" \
    -backend-config="subscription_id=$ARM_SUBSCRIPTION_ID" \
    -backend-config="tenant_id=$tenantId"
    #-backend-config="client_id=$servicePrincipalId" \
    #-backend-config="client_secret=$servicePrincipalKey"

    terraform workspace new $environment 2> /dev/null
    terraform workspace select $environment

    rm -rf .terraform
    cd ../..

done
pwd

ls -Flah
ls -Flah $kitPath/Layers/$environment
ls -Flah ./layer-$layerType
[ -f $kitPath/Layers/$environment/var-$layerName-dependencies.tf ] && cat $kitPath/Layers/$environment/var-$layerName-dependencies.tf || echo "no dependencies"