resource_group_name = "jstart-all-dev-02012022"

name              = "jstartall02012022law"
sku               = "PerGB2018"
retention_in_days = 30
key_vault_name    = null #"jstartall02012022kv"

log_analytics_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
