resource_group_name = "jstart-all-dev-02012022"

postgresql_servers = {
  pgsql1 = {
    name                             = "jstartall02012022postgre"
    sku_name                         = "GP_Gen5_8"
    storage_mb                       = 5120
    backup_retention_days            = 7
    enable_geo_redundant_backup      = false
    enable_auto_grow                 = true
    administrator_login              = "azure"
    administrator_login_password     = null
    version                          = "11"
    enable_ssl_enforcement           = true
    create_mode                      = "Default"
    enable_public_network_access     = false # set this to false if you want DB to be accesable via PE
    ssl_minimal_tls_version_enforced = "TLS1_2"
    assign_identity                  = true
    allowed_networks = [{ # define it as empty list if you are accessing it via PE
      subnet_name               = "loadbalancer"
      vnet_name                 = null #jstartvmssfirst"
      networking_resource_group = "jstart-all-dev-02012022"
    }]
    firewall_rules = [{ # define it as null if you are accessing it via PE
      name             = "postgresql-firewall-rule-default"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }]
  }
}

postgresql_databases = {
  db1 = {
    name       = "postgresqldb1"
    server_key = "pgsql1"
  }
}

postgresql_configurations = {}
key_vault_name            = null #"jstartall02012022kv"

postgresql_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
  pe_enable    = true
}
