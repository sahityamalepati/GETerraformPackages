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
    kitPath="kits/$basedOnStratumKitName/"
fi

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
export ARM_USE_MSI=true

echo "Move layer PS* files to layer source"
mv $kitPath/Layers/$environment/var-$layerName.* ./layer-$layerType
mv $kitPath/Layers/$environment/$layerName.* ./layer-$layerType
mv $kitPath/Layers/$environment/$inputFile.* ./layer-$layerType

cd ./layer-$layerType
ls -Flah

chmod +x $inputFile 2> /dev/null
chmod +x main.apply.ps1
pwsh ./main.apply.ps1 -layerName $layerName \
-environment $environment \
-backendResourceGroupName $backendResourceGroupName \
-backendStorageAccountName $backendStorageAccountName \
-backendContainername $backendContainername \
-buildRepositoryName $buildRepositoryName \
-basedOnStratumKitName $basedOnStratumKitName \
-layerType $layerType \
-layerDestroy $layerDestroy \
-kitPath $kitPath \
-provider $provider \
-inputFile $inputFile