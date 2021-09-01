#! /bin/bash

# Uncomment the below line to install az cli for Ubuntu 16.04+ and Debian 8+.
# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

################################################################

# Uncomment the below lines to install az cli for Linux distributions with yum such as RHEL, Fedora, or CentOS, there's a package for the Azure CLI.
# rpm --import https://packages.microsoft.com/keys/microsoft.asc

# sudo sh -c 'echo -e "[azure-cli]
# name=Azure CLI
# baseurl=https://packages.microsoft.com/yumrepos/azure-cli
# enabled=1
# gpgcheck=1
# gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

# sudo yum install azure-cli -y

###############################################################

az login --identity

# Get KV Certificate Value
certificateValue=$(az keyvault certificate show --vault-name ${keyvaultName} --name ${certificateName} --query "cer"  -o tsv )
echo $certificateValue

# Download KV Certificate
az keyvault certificate download --name ${certificateName} --vault-name ${keyvaultName} --file ${downloadedCertificateName}
chmod 400 ${downloadedCertificateName}
cat ${downloadedCertificateName}