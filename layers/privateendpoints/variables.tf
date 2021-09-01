variable "resource_group_name" {
  type        = string
  description = "Resource Group name of private endpoint. If private endpoint is crated in bastion vnet then private endpoint can only be created in bastion subscription resource group"
}

variable "pe_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -	
# - Private Endpoints
# -
variable "private_endpoints" {
  type = map(object({
    name                      = string
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
    resource_name             = string
    group_ids                 = list(string)
    approval_required         = bool
    approval_message          = string
  }))
  description = "Map containing Private Endpoint and Private DNS Zone details"
  default     = {}
}

variable "external_resource_ids" {
  type        = map(string)
  description = "Specifies the map of bastion/external resource ids"
  default     = {}
}

variable "approval_message" {
  type        = string
  description = "A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource"
  default     = "Please approve my private endpoint connection request"
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
