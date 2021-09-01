resource_group_name = "jstart-all-dev-02012022"

server_name                         = "jstartall02012022azsql"
database_names                      = ["azuresqldb02012022"]
administrator_login_name            = "dbadmin"
sku_name                            = "BC_Gen5_2"
azuresql_version                    = "12.0"
assign_identity                     = true
max_size_gb                         = 4
elastic_pool_id                     = null
create_mode                         = null
creation_source_database_id         = null
restore_point_in_time               = null
private_endpoint_connection_enabled = true
enable_failover_server              = false
failover_location                   = null
key_vault_name                      = null #"jstartall02012022kv"

allowed_networks = [{
  subnet_name               = "loadbalancer"
  vnet_name                 = null #"jstartvmssfirst"
  networking_resource_group = "jstart-all-dev-02012022"
}]

firewall_rules = {
  rule1 = {
    name             = "azuresql-firewall-rule-default"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "0.0.0.0"
  }
}

azuresql_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
  pe_enable    = true
}
