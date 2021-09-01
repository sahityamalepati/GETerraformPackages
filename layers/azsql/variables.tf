variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the MySQL Server"
}

variable "azuresql_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default = {
    pe_enable = true
  }
}

# -
# - Azure SQL Server
# -
variable "server_name" {
  type        = string
  description = "The name of the Azure SQL Server"
  default     = null
}

variable "database_names" {
  type        = list(string)
  description = "List of Azure SQL database names"
  default     = []
}

variable "administrator_login_name" {
  type        = string
  description = "The administrator username of Azure SQL Server"
  default     = "dbadmin"
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator password of the Azure SQL Server"
  default     = null
}

variable "allowed_networks" {
  type = list(object({
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
  }))
  description = "The List of networks that the Azure SQL server will be connected to."
  default     = []
}

variable "azuresql_version" {
  type        = string
  description = "Specifies the version of Azure SQL Server ti use. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  default     = "12.0"
}

variable "assign_identity" {
  type        = bool
  description = "Specifies whether to enable Managed System Identity for the Azure SQL Server"
  default     = true
}

variable "minimum_tls_version" {
  type        = string
  description = "The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2."
  default     = "1.2"
}

variable "max_size_gb" {
  type        = number
  description = "The max size of the database in gigabytes"
  default     = 4
}

variable "sku_name" {
  type        = string
  description = "Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100."
  default     = "BC_Gen5_2"
}

variable "elastic_pool_id" {
  type        = string
  description = "Specifies the ID of the elastic pool containing this database."
  default     = null
}

variable "create_mode" {
  type        = string
  description = "The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary."
  default     = null
}

variable "creation_source_database_id" {
  type        = string
  description = "The id of the source database to be referred to create the new database. This should only be used for databases with create_mode values that use another database as reference. Changing this forces a new resource to be created."
  default     = null
}

variable "restore_point_in_time" {
  type        = string
  description = "Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create_mode= PointInTimeRestore databases."
  default     = null
}

variable "firewall_rules" {
  type = map(object({
    name             = string # (Required) Specifies the name of the Azure SQL Firewall Rule. 
    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
  }))
  description = "List of Azure SQL Server firewall rule specification"
  default     = {}
}

variable "private_endpoint_connection_enabled" {
  type        = bool
  description = "Specify if only private endpoint connections will be allowed to access this resource"
  default     = true
}

variable "enable_failover_server" {
  type        = bool
  description = "If set to true, enable failover Azure SQL Server"
  default     = false
}

variable "failover_location" {
  type        = string
  description = "Specifies the supported Azure location where the failover Azure SQL Server exists"
  default     = null
}

variable "read_write_endpoint_failover_policy_mode" {
  type        = string
  description = "The failover mode. Possible values are Manual, Automatic"
  default     = "Automatic"
}

variable "auditing_storage_account_name" {
  type        = string
  description = "Specifies the existing storage account name where you want to store AZ Sql auditing logs."
  default     = null
}

variable "auditing_retention_in_days" {
  type        = string
  description = "Specifies the number of days to retain logs for in the storage account."
  default     = "6"
}

variable "cmk_enabled_transparent_data_encryption" {
  type        = bool
  description = "Enable Azure SQL Transparent Data Encryption (TDE) with customer-managed key?"
  default     = false
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store AZ Sql Server Password and CMK Key."
  default     = null
}

variable "geo_secondary_key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store CMK Key for secondary region."
  default     = null
}

variable "geo_secondary_key_vault_rg_name" {
  type        = string
  description = "Specifies the existing Resource Group Name for Key Vault where you want to store CMK Key for secondary region."
  default     = null
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
