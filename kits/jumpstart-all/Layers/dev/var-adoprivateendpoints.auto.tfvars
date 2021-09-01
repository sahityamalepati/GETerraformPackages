ado_private_endpoints = {
  ape1 = {
    name          = "jstartall02012022"
    resource_name = "jstartall02012022kv"
    group_ids     = ["vault"]
    dns_zone_name = "privatelink.vaultcore.azure.net"
  }
}

# resource_ids = {
#   "jstartall02012022kv" = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/Microsoft.KeyVault/vaults/jstartall02012022kv"
# }

ado_resource_group_name = "ge001-eastus2-devops-rg"
ado_vnet_name           = "strm01-eastus2-devops-vnet"
ado_subnet_name         = "strm01-eastus2-agent_pool-snet"
ado_subscription_id     = "04bb49da-c3e1-4bb6-89e1-a693b608d762"

ado_pe_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}