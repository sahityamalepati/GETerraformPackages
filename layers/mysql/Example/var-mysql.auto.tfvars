resource_group_name = "[__resoure_group_name__]"

server_name                         = "jstartall11222020mysql"
database_names                      = ["jstart11222020mysqldb"]
administrator_user_name             = "adminusername"
administrator_login_password        = null
sku_name                            = "GP_Gen5_2"
mysql_version                       = "5.7"
create_mode                         = null
creation_source_server_id           = null
restore_point_in_time               = null
storage_mb                          = 5120
backup_retention_days               = 7
geo_redundant_backup_enabled        = false
auto_grow_enabled                   = true
private_endpoint_connection_enabled = true
ssl_minimal_tls_version             = "TLS1_2"
infrastructure_encryption_enabled   = false
key_vault_name                      = null #"jstartall11222020kv"

allowed_networks = [{
  subnet_name               = "loadbalancer"
  vnet_name                 = null #"jstartvmssfirst"
  networking_resource_group = "[__networking_resoure_group_name__]"
}]

firewall_rules = {
  "default" = {
    name             = "mysql-firewall-rule-default"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }
}

mysql_configurations = {
  interactive_timeout = "600"
}

mysql_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
  pe_enable    = true
}
