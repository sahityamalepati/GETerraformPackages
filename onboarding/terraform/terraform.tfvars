vnet_rg_name            = "vnet_rg" # name of the RG where the existing vnet resides
vnet_name               = "vnet_main" # name of existing vnet name deployed by GE automation
subnet_name             = "agent_subnet_001" # name of the subnet that you wish to deploy
subnet_prefix           = "10.0.4.0/24" # prefix of subnet such as 10.0.0.0/24
userID                  = "denreed" # this should be your UID that will be used for resource tags
appid                   = "ge001"
subscription_id         = "04bb49da-c3e1-4bb6-89e1-a693b608d762" # this should be the subscription ID of the NPRD subscription in which you want to deploy
region                  = "eastus2" # eastus2, westus2, etc are the options available.
#vm_admin_password       = "" #uncomment and set this if you want to use a password for the agent nodes

#optional additional resources based on application environment
deploy_acr                = false #deploy ACR and its associated PE. Required if application environment will be using AKS
deploy_sig                = false #deploy Shared Image Gallery. Required if application environment will be using packer images
deploy_azure_websites_dns = false #deploy Azure Websites DNS zone. Required if application environment will be using Azure Web Apps