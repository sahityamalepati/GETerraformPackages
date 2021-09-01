data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_key_vault" "this" {
  count               = local.keyvault_state_exists == false ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

resource "random_id" "this" {
  keepers = {
    rg = var.resource_group_name
  }
  byte_length = 5
}

locals {
  tags                       = merge(var.log_analytics_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true

  log_analytics_name = var.name != null ? var.name : substr("log-anaylytics-name-${random_id.this.hex}", 0, 23) #name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
}

# -
# - Create Log Analytics Workspace
# -
resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location

  sku               = var.sku
  retention_in_days = var.retention_in_days

  tags = local.tags
}

# -
# - Install the VMInsights solution
# -
resource "azurerm_log_analytics_solution" "this" {
  solution_name         = "VMInsights"
  location              = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name   = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}

# -	
# - Store LAW Workspace Id and Primary Key to Key Vault Secrets	
# -	
locals {
  log_analytics_workspace = {
    law-primary-shared-key = azurerm_log_analytics_workspace.this.primary_shared_key
    law-workspace-id       = azurerm_log_analytics_workspace.this.workspace_id
    law-resource-id        = azurerm_log_analytics_workspace.this.id
  }
}

resource "azurerm_key_vault_secret" "this" {
  for_each     = local.log_analytics_workspace
  name         = each.key
  value        = each.value
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  depends_on   = [azurerm_log_analytics_workspace.this]
}
