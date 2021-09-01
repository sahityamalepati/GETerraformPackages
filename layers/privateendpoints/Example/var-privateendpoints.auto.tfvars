resource_group_name = "jstart-vm-dev-111420"

private_endpoints = {
  pe1 = {
    resource_name             = "jstartvmdev111420kv"
    name                      = "privateendpointkeyvault"
    subnet_name               = "proxy"
    vnet_name                 = null #"jstartvmfirst"
    networking_resource_group = null
    group_ids                 = ["vault"]
    approval_required         = false
    approval_message          = null
  }
}

# resource_ids = {
#   "jstartvmdev111420kv" = "/subscriptions/9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51/resourceGroups/jstart-vm-dev-111420/providers/Microsoft.KeyVault/vaults/jstartvmdev111420kv"
# }

external_resource_ids = {}

pe_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
