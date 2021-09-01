resource_group_name = "[__resoure_group_name__]"

aks_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}

# - AKS
aks_clusters = {
  "aks1" = {
    name                            = "jstartalldev11222020"
    sku_tier                        = "Free"
    dns_prefix                      = "jstartalldev11222020"
    kubernetes_version              = "1.18.8"
    docker_bridge_cidr              = "172.17.0.1/16"
    service_address_range           = "10.0.16.0/24"
    dns_ip                          = "10.0.16.2"
    rbac_enabled                    = true
    cmk_enabled                     = true
    assign_identity                 = true
    auto_scaler_profile             = null
    admin_username                  = "aksadminuser"
    api_server_authorized_ip_ranges = null
    network_plugin                  = null
    network_policy                  = null
    pod_cidr                        = null
    managed                         = true
    admin_group_object_ids          = ["ea31a15d-2429-4a4d-8d82-bc1c5d113a8c"]
    aks_default_pool = {
      name                      = "jstartall"
      vm_size                   = "Standard_B2ms"
      availability_zones        = [1, 2, 3]
      enable_auto_scaling       = true
      max_pods                  = 30
      os_disk_size_gb           = 30
      subnet_name               = "loadbalancer"
      vnet_name                 = null #"jstartvmssfirst"
      networking_resource_group = "[__networking_resoure_group_name__]"
      node_count                = 1
      min_count                 = 1
      max_count                 = 1
    }
    load_balancer_profile = null
  }
}

aks_extra_node_pools = {
  np1 = {
    name                      = "jstartallnp"
    aks_key                   = "aks1"
    vm_size                   = "Standard_B2ms"
    availability_zones        = [1, 2, 3]
    enable_auto_scaling       = true
    max_pods                  = 30
    mode                      = null
    os_disk_size_gb           = 30
    subnet_name               = "loadbalancer"
    vnet_name                 = null #"jstartvmssfirst"
    networking_resource_group = "[__networking_resoure_group_name__]"
    node_count                = 1
    max_count                 = 1
    min_count                 = 1
  }
}

loganalytics_workspace_name = null #"jstartall11222020law"
key_vault_name              = null #"jstartall11222020kv"

# - Private DNS for ADO agent connectivity
ado_subscription_id             = "9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51"
ado_aks_private_endpoint_name   = "jstartalldev11222020-aks"
ado_subnet_name                 = "eastus2-msft-devops-vnet-snet"
ado_vnet_name                   = "eastus2-msft-devops-vnet"
ado_aks_private_connection_name = "ado-to-aks-jstartalldev11222020"
ado_resource_group_name         = "msft-eastus2-devops-rg"
ado_private_dns_vnet_link_name  = "jstartalldev11222020-aks"

# Azure container registry 
acr_name                    = "acr11222020"
acr_subnet_name             = "proxy"
acr_vnet_name               = null #"jstartvmssfirst"
acr_pe_name                 = "jstartalldev11222020-acr"
acr_resource_group_name     = "[__acr_resoure_group_name__]"
acr_rg_location             = "eastus2"
pe_acr_record_name          = "acr11222020"
pe_acr_vnetlink_name        = "jstartalldev11222020-acr"
acr_private_connection_name = "jstartalldev11222020-acr"

# RBAC
# - IF AD integration is set to true the following attributes are required. The   
ad_enabled = true

###  Start AD integration config variables
# Base Key Vault where the information will client app id , server app id and 
mgmt_key_vault_name = "base-infra-aks-kv"
mgmt_key_vault_rg   = "base-infra-aks-rg"

# secret name of objects stored in the key vault    
aks_client_app_id     = "aks-client-app-id"
aks_server_app_id     = "aks-server-app-id"
aks_server_app_secret = "aks-server-app-secret"

# attributes used to PE to Key Vault 
kv_resource_id = "/subscriptions/9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51/resourceGroups/base-infra-aks/providers/Microsoft.KeyVault/vaults/base-aks"
pe_kv_name     = "pe-kv-aks"
###  END AD integration config variables 

aks_client_id     = null
aks_client_secret = null