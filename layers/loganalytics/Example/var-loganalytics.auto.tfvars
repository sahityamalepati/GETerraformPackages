resource_group_name = "jstart-vmss-layered07142020"

name              = "jstartlayer07142020law"
sku               = "PerGB2018"
retention_in_days = 30

log_analytics_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
