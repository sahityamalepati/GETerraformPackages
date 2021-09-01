<#
VTIL Installation script
Authors: Bhaskar Shekar, Austin Mleziva

Requirements:
VM must have MSI added as blob reader to storage account
blob must contain zip file with the following at the root level:
ColdFusion_2018_WWEJ_win64.exe - Cold fusion installer
jvm.config - VTIL JVM Config must be copied to C:\ColdFusion2018\cfusion\bin directory
server.xml - server.xml config must be copied to C:\ColdFusion2018\cfusion\runtime\conf directory. Contains placeholders
silent.properties - ColdFusion silent installer settings. Contains placeholders
Git-2.17.0-64-bit.exe - git installer
git.inf - git installer configuration
rewrite_amd64_en-US.msi - url rewrite installer

Functionality:
Installs ColdFusion
Configures IIS for VTIL
Installs IIS CF Connector

Sample Run: 
./AppDeploy.ps1 -Environment "poc1" -KeyVaultName "vtil-poc1-kv-03" -VtilHostname "vtil-az.test.att.com" -CertificateName "vtil.dev.att.com.pfx"

#>

param(
    [string]$Environment                                                    = $(throw "Environment is required"),
    [string]$StorageAccountName                                             = "17031deploymentsstatt",
    [string]$ContainerName                                                  = "appdependencies",
    [ValidatePattern("((.*)(\.(?i)(zip))$)")][string]$BlobName              = "appdependencies.zip",
    [string]$KeyVaultName                                                   = $(throw "KeyVaultName is required"),
    [string]$VtilHostname                                                   = $(throw "VtilHostname is required"),
    [string]$CertificateName                                                = $(throw "CertificateName is required")
)


#####################################################################################################
#Set Variables
#####################################################################################################
Write-Output "Started appdeploy.ps1 $(Get-Date)"

$homeDirectory                  = "E:\deployment-vtil"
$logFileName                    = "appDeploy-$(Get-Date -Format "yyyy_MM_dd_HH_mm").txt"

$fileName                       = $BlobName.Split(".")[0]
$installDirectory               = "$homeDirectory\$fileName"

$certificateSecretName          = "vtil-cert" #this will just vtil-cert on non-poc
$certificatePasswordSecretName  = "VtilCertificatePassword"
$certificatePath                = "$installDirectory\$CertificateName"  

$coldFusionKeyStorePath         = $certificatePath

$coldFusionDir                  = "E:\\ColdFusion2018"  
$coldFusionFileName             = "ColdFusion_2018_WWEJ_win64.exe"  
$coldFusionJvmConfigFileName    = "jvm.config"  
$coldFusionServerXmlFileName    = "server.xml"  
$coldFusionPropertiesName       = "silent.properties"  
$coldFusionJvmConfigPath        = "$coldFusionDir\cfusion\bin"
$coldFusionServerxmlPath        = "$coldFusionDir\cfusion\runtime\conf"

$jvmGatekeeperPath              = "E:\\vtil\\vtil\\Gatekeeper"
$jvmJavaHomePath                = "$coldFusionDir\\jre"

$coldFusionAdminSecretName      = "ColdFusionAdminPassword"  
$coldFusionRDSSecretName        = "ColdFusionRDSPassword"  
$coldFusionJettySecretName      = "ColdFusionJettyPassword"  
$coldFusionKeyStoreSecretName   = "ColdFusionKeyStorePassword"  

$gitInstallerName               = "Git-2.17.0-64-bit.exe"
$gitInstallSettingsName         = "git.inf"
$gitInstallLocation             = "E:\Program Files\Git"
$gitUserSecretName              = "GitUser"
$gitPasswordSecretName          = "GitPassword"
$gitExeLocation                 = "E:\Program Files\Git\bin\git.exe"

$vtilCodeCloud                  = "codecloud.web.att.com/scm/st_ott/vtil.git"
$vtilCloneLocation              = "E:\vtil\vtil"                     

$iisAppPoolName                 = "vtil"
$iisAppPoolDotNetVersion        = "v4.0"
$iisWebsiteFolderPath           = "E:\vtil"                
$iisWebsiteName                 = "vtil"
$redirectPage                   = "https://$VtilHostname/vtil"


#####################################################################################################
#Download packages and execute prerequisites
#####################################################################################################
Write-Output "Clean and Create Home Directory: $homeDirectory"
Get-ChildItem $homeDirectory -Recurse -Force | Remove-Item -Recurse -Force
New-Item -Path $homeDirectory -Type Directory -ErrorAction SilentlyContinue
cd $homeDirectory
Start-Transcript -Path "$homeDirectory\$logFileName"

$env:HTTPS_PROXY="proxy.conexus.svc.local:3128"
Write-Output "Set proxy to $env:HTTPS_PROXY"

Write-Output "Clean and Create vtil directory: $vtilCloneLocation"
Get-ChildItem $vtilCloneLocation -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
New-Item -Path $vtilCloneLocation -Type Directory -ErrorAction SilentlyContinue

Write-Output "Get MSI Storage Account Token"
$token=(Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F").access_token;
$headers = @{ "Authorization" = "Bearer $token"; "x-ms-version" = "2017-11-09" };

Write-Output "Download and extract $BlobName"
$ProgressPreference="SilentlyContinue"
Invoke-WebRequest -UseBasicParsing -Headers $headers -Method Get -Uri "https://$StorageAccountName.blob.core.windows.net/$ContainerName/$BlobName" -OutFile .\$BlobName
Expand-Archive -Path $BlobName -Force

Write-Output "Change to install directory: $fileName"
cd $fileName

#####################################################################################################
# Install Cold Fusion
#####################################################################################################   
Write-Output "Get MSI Key Vault Token"
$kvtoken=(Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net").access_token;
$kvheaders = @{ "Authorization" = "Bearer $kvtoken"; "x-ms-version" = "2017-11-09" };

Write-Output "Load required secrets from key vault"
$coldfusionadminpassword = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${coldFusionAdminSecretName}?api-version=2016-10-01").value
$coldFusionRDSPassword = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${coldFusionRDSSecretName}?api-version=2016-10-01").value
$coldFusionJettyPassword = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${coldFusionJettySecretName}?api-version=2016-10-01").value
$certificatePassword = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${certificatePasswordSecretName}?api-version=2016-10-01").value

Write-Output "Load ${certificateSecretName} from Key Vault and convert to PFX"
$base64VtilCertificate = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${certificateSecretName}?api-version=2016-10-01").value
$bytes = [Convert]::FromBase64String($base64VtilCertificate)
[IO.File]::WriteAllBytes($certificatePath, $bytes)

Write-Output "Replace placeholders in $coldFusionPropertiesName"
$coldFusionPropertiesPath = ".\$coldFusionPropertiesName"
(Get-Content $coldFusionPropertiesPath).replace('${SILENT_INSTALL_FOLDER}', $coldFusionDir) | Set-Content $coldFusionPropertiesPath
(Get-Content $coldFusionPropertiesPath).replace('${SILENT_ADMIN_PASSWORD}', $coldfusionadminpassword) | Set-Content $coldFusionPropertiesPath
(Get-Content $coldFusionPropertiesPath).replace('${SILENT_SERIAL_NUMBER}', '') | Set-Content $coldFusionPropertiesPath

Write-Output "Opening windows firewall rule for coldfusion"                  
New-NetFirewallRule -DisplayName 'coldfusion port' -Profile 'Private' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 8443

Write-Output "ColdFusion install started: $coldFusionFileName"
$Process = Start-Process -FilePath ".\$coldFusionFileName" -ArgumentList "-f .\$coldFusionPropertiesName" -PassThru -Verb RunAs
#Need to use WaitForExit because Start-Process -Wait does not return when using az vm run-command
$Process.WaitForExit()
Write-Output "ColdFusion install Finished with Exit Code: $($Process.ExitCode)"

Write-Output "Copy JVM config settings to $coldFusionJvmConfigPath"  
$jvmConfigPath = ".\$coldFusionJvmConfigFileName"
(Get-Content $jvmConfigPath).replace('${GATEKEEPER_PATH}', $jvmGatekeeperPath) | Set-Content $jvmConfigPath
(Get-Content $jvmConfigPath).replace('${JAVA_HOME_PATH}', $jvmJavaHomePath) | Set-Content $jvmConfigPath
Copy-Item -Path .\$coldFusionJvmConfigFileName -Destination "$coldFusionJvmConfigPath\$coldFusionJvmConfigFileName" -force

Write-Output "Update server.xml settings and copy to $coldFusionServerxmlPath"  
$serverXmlPath = ".\$coldFusionServerXmlFileName"
(Get-Content $serverXmlPath).replace('${KEYSTORE_FILE_PATH}', $coldFusionKeyStorePath) | Set-Content $serverXmlPath
(Get-Content $serverXmlPath).replace('${KEYSTORE_PASSWORD}', $certificatePassword) | Set-Content $serverXmlPath
Copy-Item -Path $serverXmlPath -Destination "$coldFusionServerxmlPath\$coldFusionServerXmlFileName" -force
#####################################################################################################
# Install git
#####################################################################################################
# https://jrsoftware.org/ishelp/index.php?topic=setupcmdline
Write-Output "git install started: $gitInstallerName" 
New-Item -Path $gitInstallLocation -Type Directory -Force
$commandLineOptions = '/SP- /VERYSILENT /SUPPRESSMSGBOXES /FORCECLOSEAPPLICATIONS /DIR="'+ $gitInstallLocation + '" /LOADINF=".\'+ $gitInstallSettingsName + '" /LOG=".\Git-install.log"'
Write-Output "With options:" $commandLineOptions
$Process = Start-Process  -FilePath .\$gitInstallerName -ArgumentList $commandLineOptions -PassThru -Wait 
Write-Output "git install Finished with Exit Code: $($Process.ExitCode)"

#####################################################################################################
# Clone vtil repository
#####################################################################################################
Write-Output "Get git password from KV" 
$gitPassword = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${gitPasswordSecretName}?api-version=2016-10-01").value
$gitUser = (Invoke-RestMethod -Headers $kvheaders -Method Get -Uri "https://$keyVaultName.vault.azure.net/secrets/${gitUserSecretName}?api-version=2016-10-01").value
Write-Output "Cloning vtil repository started: $vtilCodeCloud to $iisWebsiteFolderPath"
$env:GIT_REDIRECT_STDERR = '2>&1'
& $gitExeLocation clone https://${gitUser}:${gitPassword}@${vtilCodeCloud} $vtilCloneLocation
Write-Output "Cloning vtil repository finished"

#####################################################################################################
#Install URL Rewrite IIS Modules
#####################################################################################################

Write-Output "URL Rewrite IIS Module install started:"
$Process = Start-Process msiexec.exe -ArgumentList "/I $installDirectory\rewrite_amd64_en-US.msi /quiet" -PassThru -Wait
Write-Output "URL Rewrite IIS Module install finished with exit code: $($Process.ExitCode)"

#####################################################################################################
# Vtil website creation with SSL Certificate and binding
#####################################################################################################
Write-Output "Create IIS app pool and site and bind certificate started"
$SecurePassword = $certificatePassword | ConvertTo-SecureString -AsPlainText -Force
$pfx = Import-PfxCertificate -FilePath $certificatePath -CertStoreLocation Cert:\LocalMachine\WebHosting -Password $SecurePassword
$certThumbprint = $pfx.Thumbprint 
Import-Module WebAdministration   

$iisWebsiteBindings = @(   
   @{protocol="http";bindingInformation="*:80:$VtilHostname"},
   @{protocol="https";bindingInformation="*:443:$VtilHostname";hostHeader="$VtilHostname";SSLFlags=1}   
)   
if (!(Test-Path IIS:\AppPools\$iisAppPoolName -pathType container))   
{   
    New-Item IIS:\AppPools\$iisAppPoolName 
}   
    
if (!(Test-Path IIS:\Sites\$iisWebsiteName -pathType container))   
{   
    New-Item IIS:\Sites\$iisWebsiteName -bindings $iisWebsiteBindings -physicalPath $iisWebsiteFolderPath   
}
Set-ItemProperty IIS:\Sites\$iisWebsiteName -name applicationPool -value $iisAppPoolName   
(Get-WebBinding -Name $iisWebsiteName -Port 443 -Protocol "https").AddSslCertificate($certThumbprint, "WebHosting") 
Write-Output "Create IIS app pool and site and bind certificate finished"
#####################################################################################################
#HTTP Redirection setting
#####################################################################################################
Write-Output "Add https redirect settings started"
Set-WebConfiguration system.webServer/httpRedirect "IIS:\sites\$iisWebsiteName" -Value @{enabled="true";destination="$redirectPage";exactDestination="false";ChildOnly="true";httpResponseStatus="Found"}
Write-Output "Add https redirect settings finished"

#####################################################################################################
#Adding Rule to http URL Rewrite Module
#####################################################################################################
Write-Output "Adding Rule to http URL Rewrite Module"
$site = "iis:\sites\vtil"
$filterRoot = "system.webServer/rewrite/rules/rule[@name='https_redirect$_']"
Clear-WebConfiguration -pspath $site -filter $filterRoot
Add-WebConfigurationProperty -pspath $site -filter "system.webServer/rewrite/rules" -name "." -value @{name='https_redirect' + $_ ;patternSyntax='Regular Expressions';stopProcessing='True'}
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/match" -name "url" -value "^(.*)"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/conditions" -name '.' -value @{input='{SERVER_PORT}'; matchType='0'; pattern='^443$'; ignoreCase='True'; negate='True'}
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "type" -value "Redirect"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "url" -value "https://{SERVER_NAME}/{R:1}"
Set-WebConfigurationProperty -pspath $site -filter "$filterRoot/action" -name "redirectType" -value "Found"
Write-Output "Added Rule to http URL Rewrite Module"

#####################################################################################################
# Install IIS CF Connector
#####################################################################################################
Write-Output "Installing IIS cold fusion Connector"
Invoke-Expression "$coldFusionDir\cfusion\runtime\bin\wsconfig.exe -ws iis -site 0 -v"
Write-Output "Installed IIS cold fusion Connector"

#todo restart IIS
#todo restart coldfusion
Write-Output "Finished appdeploy.ps1 $(Get-Date)"
Stop-Transcript
#####################################################################################################
# Upload Logs to Storage Account
#####################################################################################################
cd $homeDirectory
$logsContainerName = "${Environment}-logs"
Write-Output "Get MSI Storage Account Token"
$token=(Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fstorage.azure.com%2F").access_token;
$headers = @{ "Authorization" = "Bearer $token"; "x-ms-version" = "2019-12-12"; "x-ms-blob-type" = "BlockBlob";    };

Write-Output "Create logs container ${logsContainerName} in storage account $StorageAccountName"
Try {
  Invoke-RestMethod -Uri "https://$StorageAccountName.blob.core.windows.net/${logsContainerName}?restype=container" -Method Put -Headers $headers
} Catch {
  $RestError = $_
  Write-Output "Caught error: $RestError"
}

Write-Output "Upload logs to $StorageAccountName ${logsContainerName}"
Invoke-RestMethod -Uri "https://$StorageAccountName.blob.core.windows.net/$logsContainerName/$logFileName" -Method Put -Headers $headers -InFile $logFileName