# -
# - Copy Certs
# -
variable "source_vault" {
  description = "Source Key Vault"
  type = string
}

variable "destination_vault" {
  description = "Destination Key Vault"
  type = string
}

variable "cert_names" {
  description = "List of cert names to be copied"
  type = list(string)
}


############################
# State File
############################
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
