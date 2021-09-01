variable "resource_group_name" {
  type        = string
  description = "Specifies the Name of the resource group in which PostgreSql should be deployed"
}

variable "postgresql_additional_tags" {
  type        = map(string)
  description = "Additional resource tags for PostgreSql Server"
  default = {
    pe_enable = true
  }
}

# -
# - PostgreSQL Server
# -
variable "postgresql_servers" {
  type = map(object({
    name                             = string
    sku_name                         = string
    storage_mb                       = number
    backup_retention_days            = number
    enable_geo_redundant_backup      = bool
    enable_auto_grow                 = bool
    administrator_login              = string
    administrator_login_password     = string
    version                          = number
    enable_ssl_enforcement           = bool
    create_mode                      = string
    enable_public_network_access     = bool
    ssl_minimal_tls_version_enforced = string
    assign_identity                  = bool
    allowed_networks = list(object({
      subnet_name               = string
      vnet_name                 = string
      networking_resource_group = string
    }))
    firewall_rules = list(object({
      name             = string # (Required) Specifies the name of the Postgrey SQL Firewall Rule. 
      start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
      end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
    }))
  }))
  description = "Specifies the map of attributes for PostgreSql Server."
  default     = {}
}

# -
# - PostgreSQL Database
# -
variable "postgresql_databases" {
  type = map(object({
    name       = string
    server_key = string
  }))
  description = "Specifies the map of attributes for PostgreSql Database."
  default     = {}
}

variable "postgresql_configurations" {
  type = map(object({
    name       = string
    server_key = string
    value      = string
  }))
  description = "Specifies the PostgreSql Configurations"
  default     = {}
}

variable "creation_source_server_id" {
  type        = string
  description = "For creation modes other then default the source server ID to use."
  default     = null
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store PostgreSql Server Password."
  default     = null
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
