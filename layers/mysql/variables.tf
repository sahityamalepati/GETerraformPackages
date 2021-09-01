variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the MySQL Server"
}

variable "mysql_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default = {
    pe_enable = true
  }
}

# -
# - MY SQL Server
# -
variable "server_name" {
  type        = string
  description = "The name of the MyQL Server"
}

variable "database_names" {
  type        = list(string)
  description = "List of MySQL database names"
}

variable "administrator_login_name" {
  type        = string
  description = "The administrator username of MySQL Server"
  default     = "dbadmin"
}

variable "administrator_login_password" {
  type        = string
  description = "The administrator password of the MySQL Server"
  default     = null
}

variable "assign_identity" {
  type        = bool
  description = "Specifies whether to enable Managed System Identity for the MySQL Server"
  default     = true
}

variable "allowed_networks" {
  type = list(object({
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
  }))
  description = "The List of networks that the MySQL server will be connected to."
  default     = []
}

variable "sku_name" {
  type        = string
  description = "Specifies the SKU Name for this MySQL Server"
  default     = "GP_Gen5_2"
}

variable "mysql_version" {
  type        = string
  description = "Specifies the version of MySQL to use. Valid values are 5.6, 5.7, and 8.0"
  default     = "5.7"
}

variable "create_mode" {
  type        = string
  description = "The creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore. Defaults to Default."
  default     = "Default"
}

variable "creation_source_server_id" {
  type        = string
  description = "For creation modes other than Default, the source server ID to use."
  default     = null
}

variable "restore_point_in_time" {
  type        = string
  description = "When create_mode is PointInTimeRestore, specifies the point in time to restore from creation_source_server_id."
  default     = null
}

variable "storage_mb" {
  type        = number
  description = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  default     = 5120
}

variable "backup_retention_days" {
  type        = number
  description = "Backup retention days for the server, supported values are between 7 and 35 days."
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  description = "Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not supported for the Basic tier."
  default     = false
}

variable "auto_grow_enabled" {
  type        = bool
  description = "Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is true."
  default     = true
}

variable "mysql_configurations" {
  type        = map(any)
  description = "Map of MySQL configuration settings to create. Key is name, value is server parameter value"
  default     = {}
}

variable "ssl_minimal_tls_version" {
  type        = string
  description = "The minimum TLS version to support on the sever. Possible values are TLSEnforcementDisabled, TLS1_0, TLS1_1, and TLS1_2. Defaults to TLSEnforcementDisabled."
  default     = "TLSEnforcementDisabled"
}

variable "infrastructure_encryption_enabled" {
  type        = bool
  description = "Whether or not infrastructure is encrypted for this server. Defaults to false. Changing this forces a new resource to be created."
  default     = false
}

variable "firewall_rules" {
  type = map(object({
    name             = string # (Required) Specifies the name of the MySQL Firewall Rule. 
    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule
    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule
  }))
  description = "List of MySQL Server firewall rule specification"
  default = {
    "default" = {
      name             = "mysql-firewall-rule-default"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}

variable "private_endpoint_connection_enabled" {
  type        = bool
  description = "Specify if only private endpoint connections will be allowed to access this resource"
  default     = true
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store MySQL Server Password."
  default     = null
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
