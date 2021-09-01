# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "identities" {
  description = "a list if identities to create at deploy time"
  type = list(object({
    name        = string
    resource_id = string
    #client_id   = string
    namespace   = string
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "namespace_name" {
  description = "the namespace used to store the helm state secret object and the charts resources"
  type        = string
  default     = "extensions"
}

variable "forceNameSpaced" {
  description = "By default, AAD Pod Identity matches pods to identities across namespaces. To match only pods in the namespace containing AzureIdentity set this to true."
  type        = bool
  default     = false
}
