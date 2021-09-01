ado_private_endpoints = {
  ape1 = {
    name          = "jstartvmdev101420kv"
    resource_name = "jstartvmdev101420kv"
    group_ids     = ["vault"]
    dns_zone_name = "privatelink.vaultcore.azure.net"
  }
}

# resource_ids = {
#   "jstartvmdev101420kv" = "/subscriptions/9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51/resourceGroups/jumpstart-windows-vm-westus2/providers/Microsoft.KeyVault/vaults/jstartvmdev101420kv"
# }

ado_resource_group_name = "ADO-Base-Infrastructure"
ado_vnet_name           = "ADOBaseInfrastructurevnet649"
ado_subnet_name         = "testakspe"
ado_subscription_id     = "9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51"

ado_pe_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
