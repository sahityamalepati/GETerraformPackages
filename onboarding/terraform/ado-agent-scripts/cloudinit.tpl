#cloud-config
package_upgrade: true
packages:
  - curl
  - wget
  - unzip
  - apt-transport-https 
  - ca-certificates 
  - gnupg-agent 
  - software-properties-common

runcmd:
 #
 # Create Folder under Home/User directory
 #
 - mkdir azagent; cd azagent
 - echo "[$(date +%F_%T)] $(pwd)" # >> ./ado_cloud_init.log
 - echo "[$(date +%F_%T)] Starting cloud_init script" # >> ./ado_cloud_init.log
 - apt install curl -y
 - apt install wget -y
 - apt install unzip -y
 #
 # Install Docker
 #
 - echo "[$(date +%F_%T)] Installing Docker"
 - apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
 - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
 - apt-key fingerprint 0EBFCD88
 - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs)  stable"
 - apt install docker.io -y
 - usermod -aG docker ${username}
 - systemctl enable docker
 - systemctl start docker
 #
 # Install Azure CLI Deb
 #
 - echo "[$(date +%F_%T)] Installing Azure CLI"
 - curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
 #
 # Install jq
 #
 - sudo apt install jq
 #
 # Install Docker Compose
 #
 - echo "[$(date +%F_%T)] Installing Docker Compose"
 - curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
 - chmod +x /usr/local/bin/docker-compose
 #
 # Install packer
 #
 - echo "[$(date +%F_%T)] Installing Packer"
 - wget https://releases.hashicorp.com/packer/1.6.1/packer_1.6.1_linux_amd64.zip
 - unzip packer*.zip
 - mv packer /usr/local/bin
 #
 # Install Terraform 
 #
 - echo "[$(date +%F_%T)] Installing Terraform"
 - wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
 - unzip terraform*.zip
 - mv terraform /usr/local/bin
 #
 # Install maven
 #
 - sudo apt install maven -y
 #
 # Install java
 #
 - sudo apt install default-jdk -y
 # 
 # Install Helm 
 # 
 - wget https://get.helm.sh/helm-v3.2.2-linux-amd64.tar.gz 
 - tar xvf helm-v3.2.2-linux-amd64.tar.gz 
 - sudo mv linux-amd64/helm /usr/local/bin/ 
 - rm helm-v3.2.2-linux-amd64.tar.gz 
 - rm -rf linux-amd64 
 - helm version
 # 
 # Install Kubectl CLI  
 # 
 - echo "[$(date +%F_%T)] Installing kubectl CLI" 
 - az aks install-cli | bash
 #
 # Install PowerShell
 # 
 - echo "[$(date +%F_%T)] Installing PowerShell" 
 - wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
 - sudo dpkg -i packages-microsoft-prod.deb
 - sudo apt-get update
 - sudo add-apt-repository universe
 - sudo apt-get install -y powershell
 #
 # Install PowerShell Modules
 # 
 - echo "[$(date +%F_%T)] Installing PowerShell modules"
 - sudo pwsh -command 'Install-Module -Name Az -AllowClobber -Force -Confirm:$false -Scope AllUsers'
 - sudo pwsh -command 'Install-Module Pester -SkipPublisherCheck -RequiredVersion 4.10.1 -Confirm:$false -Force -Scope AllUsers'
 - sudo touch /cloudinitfinished.txt
 