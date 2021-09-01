# -
# - Core object
# -

variable "common_vars" {}
variable "rg_name"{}

variable "network_ddos_protection_plan" {
  description = "Network network ddos protection plan parameters."
  type        = string
  default     = "Basic"
}

# -
# - Network object
# -
variable "virtual_networks" {}

variable "subnets" {}

variable "route_tables" {
  default     = {}
}



# -
# - AdHoc
# -

############################
# storage account
############################

variable "container_name" {
  type    = list(string)
  default = []
}
###### Key Vault

variable "network_acls" {
  default = null
  type    = any
}
