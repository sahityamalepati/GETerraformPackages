data "azurerm_resource_group" "this" {
  for_each = var.flow_logs
  name     = each.value["network_watcher_rg_name"]
}

data "azurerm_storage_account" "this" {
  for_each            = local.storage_state_exists == false ? var.flow_logs : {}
  name                = each.value.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "this" {
  count               = (local.loganalytics_state_exists == false && var.loganalytics_workspace_name != null) ? 1 : 0
  name                = var.loganalytics_workspace_name
  resource_group_name = var.resource_group_name
}

data "azurerm_network_security_group" "this" {
  for_each            = local.networksecuritygroup_state_exists == false ? var.flow_logs : {}
  name                = each.value.nsg_name
  resource_group_name = var.resource_group_name
}

locals {
  storage_state_exists              = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  loganalytics_state_exists         = length(values(data.terraform_remote_state.loganalytics.outputs)) == 0 ? false : true
  networksecuritygroup_state_exists = length(values(data.terraform_remote_state.networksecuritygroup.outputs)) == 0 ? false : true
}

resource "azurerm_network_watcher_flow_log" "this" {
  for_each             = var.flow_logs
  network_watcher_name = each.value["network_watcher_name"]
  resource_group_name  = lookup(data.azurerm_resource_group.this, each.key)["name"]

  network_security_group_id = local.networksecuritygroup_state_exists == true ? lookup(data.terraform_remote_state.networksecuritygroup.outputs.nsg_id_map, lookup(each.value, "nsg_name")) : lookup(data.azurerm_network_security_group.this, each.key)["id"]
  storage_account_id        = local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, lookup(each.value, "storage_account_name")) : lookup(data.azurerm_storage_account.this, each.key)["id"]
  enabled                   = true

  retention_policy {
    enabled = true
    days    = coalesce(lookup(each.value, "retention_days"), 7)
  }

  dynamic "traffic_analytics" {
    for_each = coalesce(lookup(each.value, "enable_traffic_analytics"), false) == true ? list(lookup(each.value, "interval_in_minutes", 7)) : []
    content {
      enabled               = true
      workspace_id          = local.loganalytics_state_exists == true ? data.terraform_remote_state.loganalytics.outputs.law_workspace_id : data.azurerm_log_analytics_workspace.this.0.workspace_id
      workspace_region      = lookup(data.azurerm_resource_group.this, each.key)["location"]
      workspace_resource_id = local.loganalytics_state_exists == true ? data.terraform_remote_state.loganalytics.outputs.law_id : data.azurerm_log_analytics_workspace.this.0.id
      interval_in_minutes   = coalesce(lookup(each.value, "interval_in_minutes"), null)
    }
  }
}
