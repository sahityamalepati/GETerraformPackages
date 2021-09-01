# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "namespace_name" {
  description = "the namespace used to store the helm state secret object and the charts resources"
  type        = string
  default     = "extensions"
}

variable "identity_selector" {
  description = "the selector from the identity binding"
  type        = string
  default     = "akv2k8s-identity"
}

variable "vault_controller_version" {
  description = "the version of akv2k8s vault controller"
  type        = string
  default     = "1.1.2"
}

variable "vault_env_injector_version" {
  description = "the version of akv2k8s vault env injector"
  type        = string
  default     = "1.1.9"
}