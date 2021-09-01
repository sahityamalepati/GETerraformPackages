data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

locals {
  tags                       = merge(var.rsv_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
}

# -
# - Recovery Services Vault
# -
resource "azurerm_recovery_services_vault" "this" {
  for_each            = var.recovery_services_vaults
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  sku                 = coalesce(lookup(each.value, "sku"), "Standard")
  soft_delete_enabled = coalesce(lookup(each.value, "soft_delete_enabled"), true)
  tags                = local.tags
}

# -
# - Azure VM Backup Policy
# -
resource "azurerm_backup_policy_vm" "this" {
  for_each            = var.recovery_services_vaults
  name                = each.value["policy_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name = azurerm_recovery_services_vault.this[each.key].name

  timezone = "UTC"

  backup {
    frequency = coalesce(lookup(each.value["backup_settings"], "frequency"), "Daily")
    time      = lookup(each.value["backup_settings"], "time")
    weekdays  = coalesce(lookup(each.value["backup_settings"], "frequency"), "Daily") == "Weekly" ? split(",", lookup(each.value["backup_settings"], "weekdays")) : null
  }

  dynamic "retention_daily" {
    for_each = coalesce(lookup(each.value["backup_settings"], "frequency"), "Daily") == "Daily" && each.value["retention_settings"] != null ? list(lookup(each.value["retention_settings"], "daily")) : []
    content {
      count = retention_daily.value
    }
  }

  dynamic "retention_weekly" {
    for_each = coalesce(lookup(each.value["backup_settings"], "frequency"), "Daily") == "Weekly" && each.value["retention_settings"] != null ? list(lookup(each.value["retention_settings"], "weekly")) : []
    content {
      count    = element(split(":", retention_weekly.value), 0)
      weekdays = split(",", element(split(":", retention_weekly.value), 1))
    }
  }

  dynamic "retention_monthly" {
    for_each = each.value["retention_settings"] != null ? (lookup(each.value["retention_settings"], "monthly") != null ? list(lookup(each.value["retention_settings"], "monthly")) : []) : []
    content {
      count    = element(split(":", retention_monthly.value), 0)
      weekdays = split(",", element(split(":", retention_monthly.value), 1))
      weeks    = split(",", element(split(":", retention_monthly.value), 2))
    }
  }

  dynamic "retention_yearly" {
    for_each = each.value["retention_settings"] != null ? (lookup(each.value["retention_settings"], "yearly") != null ? list(lookup(each.value["retention_settings"], "yearly")) : []) : []
    content {
      count    = element(split(":", retention_yearly.value), 0)
      weekdays = split(",", element(split(":", retention_yearly.value), 1))
      weeks    = split(",", element(split(":", retention_yearly.value), 2))
      months   = split(",", element(split(":", retention_yearly.value), 3))
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }

  tags = local.tags

  depends_on = [azurerm_recovery_services_vault.this]
}
