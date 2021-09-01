resource_group_name = "jstart-all-dev-02012022" # "<resource_group_name>"

name                                = "acr02012022" # container_name
sku                                 = "Premium"     # SKU for container registry
georeplication_locations            = ["eastus"]    # list of geo-replicated azure locations
admin_enabled                       = true          # if(admin user is enabled) then set this to <true> otherwise <false>
private_endpoint_connection_enabled = true
assign_identity                     = true
enable_cmk                          = false

allowed_networks         = null # list of networks from which requests will match the netwrok rule
allowed_external_subnets = ["/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/ge001-eastus2-devops-rg/providers/Microsoft.Network/virtualNetworks/strm01-eastus2-devops-vnet/subnets/strm01-eastus2-agent_pool-snet"]

key_vault_resource_group = "ge001-eastus2-devops-rg"
key_vault_name           = "ge001-eastus2-devops-rg"
ado_subscription_id      = "04bb49da-c3e1-4bb6-89e1-a693b608d762"

acr_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}