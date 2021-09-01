data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  for_each            = local.storage_state_exists == false ? { for x in local.redis_configuration_sa_list : x.key => x } : {}
  name                = each.value.name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? var.redis_cache_instances : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

locals {
  tags                       = merge((local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags), var.redis_cache_additional_tags)
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true

  redis_configuration_sa_list = flatten([
    for rc_k, rc_v in var.redis_cache_instances : [
      for config in(rc_v.redis_configuration != null ? [rc_v.redis_configuration] : []) : {
        key  = rc_k
        name = config.backup_storage_account_name
      } if(config.rdb_backup_enabled == true && config.backup_storage_account_name != null)
    ]
  ])
}

# -
# - Azure Redis Cache
# -
resource "azurerm_redis_cache" "this" {
  for_each            = var.redis_cache_instances
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  capacity            = each.value["capacity"]
  family              = contains(["Basic", "Standard"], each.value.sku) == true ? "C" : "P"
  sku_name            = coalesce(each.value.sku, "Standard")

  enable_non_ssl_port = coalesce(each.value.enable_non_ssl_port, false)
  minimum_tls_version = coalesce(each.value.minimum_tls_version, "1.2")
  subnet_id           = (coalesce(each.value.sku, "Standard") == "Premium" && lookup(each.value, "subnet_name", null) != null) ? (local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]) : null
  shard_count         = coalesce(each.value.sku, "Standard") == "Premium" ? lookup(each.value, "shard_count", null) : null

  private_static_ip_address = lookup(each.value, "static_ip", null)

  dynamic "patch_schedule" {
    for_each = coalesce(each.value.sku, "Standard") == "Premium" ? coalesce(each.value.patch_schedules, []) : []
    content {
      day_of_week    = patch_schedule.value.day_of_week
      start_hour_utc = patch_schedule.value.start_hour_utc
    }
  }

  dynamic "redis_configuration" {
    for_each = lookup(each.value, "redis_configuration", null) != null ? [each.value.redis_configuration] : []
    content {
      enable_authentication           = coalesce(redis_configuration.value.enable_authentication, true)
      maxmemory_reserved              = contains(["Premium", "Standard"], each.value.sku) == true ? lookup(redis_configuration.value, "maxmemory_reserved", null) : null
      maxmemory_delta                 = contains(["Premium", "Standard"], each.value.sku) == true ? lookup(redis_configuration.value, "maxmemory_delta", null) : null
      maxfragmentationmemory_reserved = contains(["Premium", "Standard"], each.value.sku) == true ? lookup(redis_configuration.value, "maxfragmentationmemory_reserved", null) : null
      maxmemory_policy                = lookup(redis_configuration.value, "maxmemory_policy", null)
      rdb_backup_enabled              = coalesce(each.value.sku, "Standard") == "Premium" ? coalesce(redis_configuration.value.rdb_backup_enabled, false) : null
      rdb_backup_frequency            = coalesce(redis_configuration.value.rdb_backup_enabled, false) == true ? redis_configuration.value.rdb_backup_frequency : null
      rdb_backup_max_snapshot_count   = coalesce(redis_configuration.value.rdb_backup_enabled, false) == true ? lookup(redis_configuration.value, "rdb_backup_max_snapshot_count", null) : null
      rdb_storage_connection_string   = coalesce(redis_configuration.value.rdb_backup_enabled, false) == true ? (local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_blob_connection_strings_map, redis_configuration.value.backup_storage_account_name) : lookup(data.azurerm_storage_account.this, each.key)["primary_blob_connection_string"]) : null
    }
  }

  lifecycle {
    ignore_changes = [redis_configuration.0.rdb_storage_connection_string]
  }

  tags = local.tags
}

# -
# - Azure Redis Cache Firewall Rule
# -
resource "azurerm_redis_firewall_rule" "this" {
  count               = length(var.firewall_rules)
  name                = element(var.firewall_rules, count.index)["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  redis_cache_name    = azurerm_redis_cache.this[element(var.firewall_rules, count.index)["redis_cache_key"]].name
  start_ip            = element(var.firewall_rules, count.index)["start_ip_address"]
  end_ip              = element(var.firewall_rules, count.index)["end_ip_address"]
  depends_on          = [azurerm_redis_cache.this]
}
