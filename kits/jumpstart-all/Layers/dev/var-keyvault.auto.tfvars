resource_group_name = "jstart-all-dev-02012022"

name                            = "jstartall02012022kv"
enabled_for_deployment          = null
enabled_for_disk_encryption     = null
enabled_for_template_deployment = null
soft_delete_enabled             = true
purge_protection_enabled        = true
sku_name                        = "standard"
secrets                         = {}
access_policies                 = {}
network_acls = {
  bypass                     = "None"
  default_action             = "Allow"
  ip_rules                   = null
  virtual_network_subnet_ids = null
}

# The value below is REQUIRED when using MSI rather than SPN. VMSS identity id
msi_object_id = "b92f2e4c-b002-4f68-b9bb-6a2e742702a2"

kv_additional_tags = {
  pe_enable    = false #true
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
