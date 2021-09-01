#! /usr/bin/pwsh

param (
    [Parameter(Mandatory)]
    [string] $TargetResourceGroup,

    [Parameter(Mandatory)]
    [string] $TargetLocation,

    [Parameter(Mandatory)]
    [string] $RsvName,

    [Parameter(Mandatory)]
    [string] $VaultRg,

    [Parameter(Mandatory)]
    [string] $RsvKey,

    [Parameter(Mandatory)]
    [string] $ReplicationPolicyName,

    [Parameter(Mandatory)]
    [string] $SourceOsDiskId,

    [Parameter(Mandatory)]
    [string[]] $Datadisks,

    [Parameter(Mandatory)]
    [string] $VmId,

    [Parameter(Mandatory)]
    [string] $CachedStorageAccountId,

    [string] $ReplicaAccountSku = "Premium_LRS",

    [string] $TargetAccountSku = "Premium_LRS",

    [Parameter(Mandatory)]
    [string] $DesName,

    [Parameter(Mandatory)]
    [string] $DesRg,

    [Parameter(Mandatory)]
    [string] $PpgName
)

Connect-AzAccount -Identity

$ppg = Get-AzProximityPlacementGroup -Name $PpgName
if ($null -eq $ppg) {
    $ppgParams = @{
        ResourceGroupName = $TargetResourceGroup
        Name              = $PpgName
        Location          = $TargetLocation
    }

    $ppg = New-AzProximityPlacementGroup @ppgParams
}

$protectionContainerMappingName = "container-mapping-${RsvKey}_${ReplicationPolicyName}"
$recoveryRg = Get-AzResourceGroup -Name $TargetResourceGroup -Location $TargetLocation
$targetDes = Get-AzDiskEncryptionSet -ResourceGroupName $DesRg -Name $DesName
$vault = Get-AzRecoveryServicesVault -Name $RsvName -ResourceGroupName $VaultRg
Set-AzRecoveryServicesAsrVaultContext -Vault $vault
$primaryFabric = Get-AzRecoveryServicesAsrFabric -Name "primary-fabric-$RsvName"
$PrimaryProtContainer = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $primaryFabric -Name "primary-protection-container-$RsvName"
$protectioncontainermapping = Get-AzRecoveryServicesAsrProtectionContainerMapping -ProtectionContainer $PrimaryProtContainer -Name $protectionContainerMappingName
$diskconfigs = @()

$osDiskConfigParams = @{
    ManagedDisk                    = $true
    LogStorageAccountId            = $CachedStorageAccountId
    DiskId                         = $SourceOsDiskId
    RecoveryResourceGroupId        = $recoveryRg.ResourceId
    RecoveryReplicaDiskAccountType = $ReplicaAccountSku
    RecoveryTargetDiskAccountType  = $TargetAccountSku
    RecoveryDiskEncryptionSetId    = $targetDes.id
}

$OsDiskReplicationConfig = New-AzRecoveryServicesAsrAzureToAzureDiskReplicationConfig @osDiskConfigParams

$diskconfigs += $OsDiskReplicationConfig

foreach ($diskId in $Datadisks) {
    $dataDiskConfigParams = @{
        ManagedDisk                    = $true
        LogStorageAccountId            = $CachedStorageAccountId
        DiskId                         = $diskId
        RecoveryResourceGroupId        = $recoveryRg.ResourceId
        RecoveryReplicaDiskAccountType = $ReplicaAccountSku
        RecoveryTargetDiskAccountType  = $TargetAccountSku
        RecoveryDiskEncryptionSetId    = $targetDes.Id
    }

    $DataDiskReplicationConfig = New-AzRecoveryServicesAsrAzureToAzureDiskReplicationConfig @dataDiskConfigParams

    $diskconfigs += $DataDiskReplicationConfig
}

$protectedItemParams = @{
    AzureToAzure                             = $true
    AzureVmId                                = $VmId
    Name                                     = (New-Guid).Guid
    ProtectionContainerMapping               = $protectioncontainermapping
    AzureToAzureDiskReplicationConfiguration = $diskconfigs
    RecoveryResourceGroupId                  = $recoveryRg.ResourceId
    RecoveryProximityPlacementGroupId        = $ppg.Id
}

New-AzRecoveryServicesAsrReplicationProtectedItem @protectedItemParams
