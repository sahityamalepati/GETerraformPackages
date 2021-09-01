variable "tenantId" {
    type = string
    description = "Tenant ID of Azure Account"
}

variable "subscriptionId" {
    type = string
    description = "Subscription within the Azure Tenant"
}

variable "resource_group_name" {
  type        = string
  description = " The name of the resource group in which to create the Action Group instance."
}

data "azurerm_resource_group" "aks_alerts" {
  name = var.resource_group_name
}