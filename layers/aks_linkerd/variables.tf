# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "trust_anchor_cert_validity_period_hours" {
  description = "Number of hours the trust anchor is valid Default: 175200 (20 years)"
  type        = number
  default     = 175200
}

variable "identity_issuer_cert_validity_period_hours" {
  description = "Number of hours the identity issuer is valid Default: 87600 (10 years)"
  type        = number
  default     = 87600
}

variable "bastion_proxy_port_number" {
  description = "Port number used by the bastion proxy"
  type        = string
  default     = "3128"
}
