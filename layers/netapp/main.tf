data "azurerm_resource_group" "this" {
  count = 1
  name  = var.resource_group_name
}

data "azurerm_subnet" "this" {
  for_each             = var.netapp_volumes
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : data.azurerm_resource_group.this.0.name
}

locals {
  location                   = var.netapp_location == null ? data.azurerm_resource_group.this.0.location : var.netapp_location
  # networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  tags                       = merge(var.netapp_additional_tags, data.azurerm_resource_group.this.0.tags)
  # resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
}

# -
# - NetApp Account
# -
resource "azurerm_netapp_account" "this" {
  count = var.existing_netapp_account == null ? 1 : 0  # condition
  name                = var.netapp_account
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.0.name
  tags                = local.tags
}

# -
# - NetApp Pools Name
# -

resource "azurerm_netapp_pool" "this" {
  for_each            = var.netapp_pools
  name                = each.value["pool_name"]
  account_name        = var.existing_netapp_account == null ? azurerm_netapp_account.this.0.name : var.existing_netapp_account
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.0.name
  service_level       = each.value["service_level"]
  size_in_tb          = each.value["size_in_tb"]
  tags                = local.tags
  depends_on          = [azurerm_netapp_account.this]
}

resource "azurerm_netapp_volume" "this" {
  for_each            = var.netapp_volumes
  name                = each.value.name
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.0.name
  account_name        = var.existing_netapp_account == null ? azurerm_netapp_account.this.0.name : var.existing_netapp_account
  pool_name           = azurerm_netapp_pool.this[each.value.pool_key].name
  volume_path         = each.value.volume_path
  service_level       = each.value.service_level
//  subnet_id           = lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name)
  subnet_id           = lookup(each.value, "subnet_name", null) == null ? null : lookup(data.azurerm_subnet.this, each.key)["id"]
  protocols           = each.value.protocols
  storage_quota_in_gb = coalesce(each.value.storage_quota_in_gb, 100)
  tags                = local.tags
  dynamic "export_policy_rule" {
    for_each = each.value.export_policy_rules
    content {
      rule_index        = index(each.value.export_policy_rules, export_policy_rule.value) + 1
      allowed_clients   = export_policy_rule.value.allowed_clients
      protocols_enabled = coalesce(export_policy_rule.value.protocols_enabled, [])
      unix_read_write   = coalesce(export_policy_rule.value.unix_read_write, true)
    }
  }

  lifecycle {
//    prevent_destroy = coaleasce(each.value.prevent_destroy, false)
    prevent_destroy = false
  }
}

# -
# - NetApp Volume Snapshot https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-manage-snapshots
# -

//resource "azurerm_netapp_snapshot" "this" {
//  for_each            = var.netapp_snapshots
//  name                = each.value.name
//  account_name        = azurerm_netapp_account.this.name
//  pool_name           = azurerm_netapp_pool.this[each.value.pool_key].name
//  volume_name         = azurerm_netapp_volume.this[each.value.volume_key].name
//  location            = local.location
//  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
//  tags                = local.tags
//}

# -
# - NetApp Snapshots Policy
# -


resource "null_resource" "snapshot_policy" {

  triggers = {
    script_param_changes = file("${path.module}/var-netapp.auto.tfvars")
    script_changes = file("${path.module}/snapshot_policy.sh")
    run_snapshot_policy = var.iterator
  }

  for_each = var.netapp_snapshot_policies
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
    command = "chmod +x ./snapshot_policy.sh && ./snapshot_policy.sh"
    environment = {
      resourceGroup           = data.azurerm_resource_group.this.0.name
      netappAccountName       = var.existing_netapp_account == null ? azurerm_netapp_account.this.0.name : var.existing_netapp_account
      snapshotPolicyName      = each.value.snapshotPolicyName
      location                = local.location
      hourlySnapshots         = each.value.hourlySnapshots
      dailySnapshots          = each.value.dailySnapshots
      monthlySnapshots        = each.value.monthlySnapshots
      monthlydays             = each.value.monthlydays
      monthlyhour             = each.value.monthlyhour
      monthlyminute           = each.value.monthlyminute
      weeklySnapshots         = each.value.weeklySnapshots
      enabled                 = each.value.enabled
      delpolicy               = each.value.delpolicy
    }
  }
}
