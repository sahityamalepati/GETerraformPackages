#! /usr/bin/pwsh
param (
    [string]$layerName,
    [string]$environment,
    [string]$backendResourceGroupName,
    [string]$backendStorageAccountName,
    [string]$backendContainername,
    [string]$buildRepositoryName,
    [string]$basedOnStratumKitName,
    [string]$layerType,
    [string]$layerDestroy,
    [string]$kitPath,
    [string]$provider,
    [string]$inputFile
)

echo "layerName: $layerName"
echo "environment: $environment"
echo "backendResourceGroupName: $backendResourceGroupName"
echo "backendStorageAccountName: $backendStorageAccountName"
echo "backendContainername: $backendContainername"
echo "buildRepositoryName: $buildRepositoryName"
echo "basedOnStratumKitName: $basedOnStratumKitName"
echo "layerType: $layerType"
echo "layerDestroy: $layerDestroy"
echo "kithPath: $kitPath"
echo "provider: $provider"
echo "inputFile: $inputFile"

If (-Not (Get-Module -Name Az)) {
    Install-Module -Name Az -Force -Confirm:$false -AllowClobber
}

gci env:* | sort-object name

$pass=ConvertTo-SecureString "$env:servicePrincipalKey" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($env:servicePrincipalId , $pass)
Connect-AzAccount -Credential $psCred -Tenant $env:tenantId -ServicePrincipal
Invoke-Expression ./$layerName.plan.ps1