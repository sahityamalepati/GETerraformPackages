variable "role_definitions" {
  description = "Map of roles definitions."
  type = map(object({
    name              = string
    description       = string
    scope             = string
    actions           = list(string)
    not_actions       = list(string)
    assignable_scopes = list(string)
  }))
  default = {}
}

variable "role_assignments" {
  description = "Map of roles assignments."
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
  default = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default = null
}