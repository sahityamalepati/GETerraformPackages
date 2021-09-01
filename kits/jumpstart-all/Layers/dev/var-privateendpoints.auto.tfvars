resource_group_name = "jstart-all-dev-02012022"

private_endpoints = {
  pe1 = {
    resource_name             = "jstartall02012022kv"
    name                      = "privateendpointkeyvault"
    subnet_name               = "proxy"
    vnet_name                 = null #"jstartvmssfirst"
    networking_resource_group = "jstart-all-dev-02012022"
    group_ids                 = ["vault"]
    approval_required         = false
    approval_message          = null
  },
  pe2 = {
    resource_name             = "functionapp02012022"
    name                      = "privateendpointazfunc"
    subnet_name               = "proxy"
    vnet_name                 = null #"jstartvmssfirst"
    networking_resource_group = "jstart-all-dev-02012022"
    group_ids                 = ["sites"]
    approval_required         = false
    approval_message          = null
  }
}

# resource_ids = {
#   "jstartall02012022kv" = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/Microsoft.KeyVault/vaults/jstartall02012022kv"
#   "functionapp02012022" = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/Microsoft.Web/sites/functionapp02012022"
# }

external_resource_ids = {}

pe_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
