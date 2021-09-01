resource_group_name = "jstart-sql-mi-dev-0111820"
sql_mi_tags = { 
  "iac" = "terraform"
}


sql_mi = {
    instance1 = {
    name                        = "sqlminew911182020"
    username                    = "misqladmin"
    subnetname                  = "ManagedInstances"
    collation                   = null
    license_type                = null
    vcores                      = null
    storage_size_in_gb          = null
    skuname                     = null  
    subnetname                  = null
    deploy_to_existing_subnet   = true
    minimum_tls_version         = null
    existing_subnet_name        = "ManagedInstances"
    existing_vnet_name          = "jstartsqlmi193120"
    existing_subnet_rg_name     = "jstart-sql-mi-dev-0193120"
  }
  }

sql_mi_db = { 
db1 = {
 name = "dbnew911182020"
 sql_mi_name = "sqlminew911182020"
 backup_retention_days = 7
 }
}