data "azurerm_resource_group" "this" {
  name  = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group_name
}

resource "azurerm_automation_account" "this" {
  name                = var.automation_account_name
  location            = var.location == null ? data.azurerm_resource_group.this.location : var.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku_name            = "Basic"
  tags                = merge(var.azure_automation_account_additional_tags, data.azurerm_resource_group.this.tags)
}

# Link automation account to a Log Analytics Workspace.
# Only deployed if enable_update_management and/or enable_change_tracking are/is set to true
resource "azurerm_log_analytics_linked_service" "law_link" {
  count               = var.enable_update_management || var.enable_change_tracking ? 1 : 0
  resource_group_name = var.log_analytics_resource_group_name
  workspace_name      = element(split("/", data.azurerm_log_analytics_workspace.this.id), length(split("/", data.azurerm_log_analytics_workspace.this.id)) - 1)
  linked_service_name = "automation"
  resource_id         = azurerm_automation_account.this.id
}


# Add Updates workspace solution to log analytics if enable_update_management is set to true.
# Adding this solution to the log analytics workspace, combined with above linked service resource enables update management for the automation account.
resource "azurerm_log_analytics_solution" "law_solution_updates" {
  count                 = var.enable_update_management ? 1 : 0
  resource_group_name   = var.log_analytics_resource_group_name
  location              = data.azurerm_log_analytics_workspace.this.location

  solution_name         = "Updates"
  workspace_resource_id = data.azurerm_log_analytics_workspace.this.id
  workspace_name        = element(split("/", data.azurerm_log_analytics_workspace.this.id), length(split("/", data.azurerm_log_analytics_workspace.this.id)) - 1)

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}


# Add Updates workspace solution to log analytics if enable_change_tracking is set to true.
# Adding this solution to the log analytics workspace, combined with above linked service resource enables Change Tracking and Inventory for the automation account.
resource "azurerm_log_analytics_solution" "law_solution_change_tracking" {
  count                 = var.enable_change_tracking ? 1 : 0
  resource_group_name   = var.log_analytics_resource_group_name
  location              = data.azurerm_log_analytics_workspace.this.location
  solution_name         = "ChangeTracking"
  workspace_resource_id = data.azurerm_log_analytics_workspace.this.id
  workspace_name        = element(split("/", data.azurerm_log_analytics_workspace.this.id), length(split("/", data.azurerm_log_analytics_workspace.this.id)) - 1)

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ChangeTracking"
  }
}
