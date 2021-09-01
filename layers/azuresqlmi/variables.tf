
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which SQL MI needs to be created"
  default = null
}

variable "sql_mi_tags" {
  type = map(string)
  default = {}
}

variable "location" {
  type = string
  description = "name of the location"
  default = null 
}

variable "key_vault_name" {
  description = "name of the key vault"
  default = null
}

variable "sql_mi" {
  type = map(object({
    name                        = string
    username                    = string
    collation                   = string
    license_type                = string
    vcores                      = number
    storage_size_in_gb          = number
    minimum_tls_version         = number
    skuname                     = string   
    subnetname                  = string
    deploy_to_existing_subnet   = bool
    existing_subnet_name        = string
    existing_vnet_name          = string
    existing_subnet_rg_name     = string 
  }))
  description = "Map of Azure SQL managed instances"
  default = {} 
 }

 variable "sql_mi_db" {
   type = map(object({
   name = string
   sql_mi_name = string
   }))
} 

 variable "deployment_time_out" {
    type = string
    default = "8h"
 }  

  