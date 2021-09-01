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