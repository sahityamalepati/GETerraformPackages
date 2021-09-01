variable "module_features" {}

variable "acr_name" {
  description = "Azure Container Registery Name"
  type        = string
}

variable "acr_rg_name" {
  description = "Azure Container Registery resource group name"
  type        = string
}

variable "acr_rg_region" {
  description = "Azure Container Registery resource group region"
  type        = string
}

variable "acr_sku" {
  description = "Azure Container Registery sku"
  type        = string
  default     = "Premium"
}

variable acr_admin_enabled {
  description = "Azure Container Registery should a staic admin account be created"
  type        = bool
  default     = false
}

# variable subnet_ids {}
variable tags {
  default = {}
}

resource "azurerm_container_registry" "acr" {
  count               = var.module_features ? 1 : 0
  name                = var.acr_name
  resource_group_name = var.acr_rg_name
  location            = var.acr_rg_region
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  tags                = var.tags

  network_rule_set {
    default_action    = "Allow"
    
  }
}

output acr_resource_id {
  value = [ for acr in azurerm_container_registry.acr : acr.id ]
}

output acr_name {
  value = [ for acr in azurerm_container_registry.acr : acr.name ]
}