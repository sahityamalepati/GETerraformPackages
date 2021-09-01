# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "release_name" {
  description = "name of the helm release"
  type        = string
  default = "nginx-ingress-controller"
}

variable "ingress_class" {
  description = "name of the ingress class to route through this controller."
  type        = string
  default     = "nginx"
}

variable "use_internal_load_balancer" {
  description = "When true an internal load balancer will be created"
  type        = bool
  default     = true
}

variable "namespace_name" {
  description = "the namespace used to store the helm state secret object and the charts resources"
  type        = string
  default     = "default"
}
