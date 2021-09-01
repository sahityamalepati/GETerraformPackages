<#
.SYNOPSIS
    Copies password-protecetd certificates from one key vault to another

.DESCRIPTION
    This script uses the Get-AzKeyVaultCertificate cmdlet to check whether the specified cert(s) already exist in the destination key vault.
    If not already present, the given certificate(s) are copied from the source to the destination key vault

.PARAMETER SubscriptionId
    The ID of the Azure subscription

.PARAMETER SourceVault
    The name of the source key vault

.PARAMETER DestinationVault
    The name of the destination key vault

.PARAMETER CertName
    The array of certificate name to check for and copy, if needed

.EXAMPLE
    $copyCertParams = @{
        SubscriptionID   = '04bb49da-c3e1-4bb6-89e1-a693b608d762'
        SourceVault      = 'source-test-kv'
        DestinationVault = 'dest-test-kv'
        CertName         = @(
            'cert1',
            'cert2',
            'cert3'
        )
    }

    Copy-Cert.ps1 @copyCertParams

    This command copies certificates named 'cert1', 'cert2', and 'cert3' from a key vault named
    'source-test-kv' to a key vault named 'dest-test-kv' in an Azure subscription with the ID '04bb49da-c3e1-4bb6-89e1-a693b608d762,'
    unless any of the certificate already exists in the destination key vault or doesn't exist in the source key vault
#>

param (
    [Parameter(Mandatory)]
    [string] $SubscriptionId,

    [Parameter(Mandatory)]
    [string] $SourceVault,

    [Parameter(Mandatory)]
    [string] $DestinationVault,

    [Parameter(Mandatory)]
    [string[]] $CertName
)

$Error.Clear()

Connect-AzAccount -Identity -SubscriptionId $SubscriptionId

foreach ($name in $CertName) {
    $destinationCert = Get-AzKeyVaultCertificate -VaultName $DestinationVault -Name $name
    if ($null -eq $destinationCert) {
        $cert = Get-AzKeyVaultCertificate -VaultName $SourceVault -Name $name
        if ($null -ne $cert) {
            $secret = Get-AzKeyVaultSecret -VaultName $SourceVault -Name $cert.Name
            $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
            try {
                $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
            }
            finally {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
            }
            $secretByte = [Convert]::FromBase64String($secretValueText)
            $x509Cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($secretByte, "", "Exportable,PersistKeySet")
            Import-AzKeyVaultCertificate -VaultName $DestinationVault -Name $name -CertificateCollection $x509Cert
        }
        else {
            Write-Error "The certificate: '$name' does not exist in key vault: '$SourceVault'"
        }
    }
    else {
        Write-Host "The certificate: '$name' already exists in key vault: '$DestinationVault'"
    }
}

if ($error.Count -gt 0) {
	$LASTEXITCODE = 1
}
