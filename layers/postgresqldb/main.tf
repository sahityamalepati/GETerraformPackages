data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_key_vault" "this" {
  count               = local.keyvault_state_exists == false ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? local.virtual_network_rules : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

# Generate random password
resource "random_password" "this" {
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags                       = merge(var.postgresql_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
}

# -
# - PostgreSQL Server
# -
resource "azurerm_postgresql_server" "this" {
  for_each            = var.postgresql_servers
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  sku_name            = each.value["sku_name"]
  version             = each.value["version"]

  storage_mb                   = each.value["storage_mb"]
  backup_retention_days        = coalesce(lookup(each.value, "backup_retention_days"), 7)
  geo_redundant_backup_enabled = coalesce(lookup(each.value, "enable_geo_redundant_backup"), false)
  auto_grow_enabled            = coalesce(lookup(each.value, "enable_auto_grow"), true)
  create_mode                  = coalesce(lookup(each.value, "create_mode"), "Default")
  creation_source_server_id    = lookup(each.value, "create_mode", "Default") != "Default" ? var.creation_source_server_id : null

  administrator_login              = each.value["administrator_login"]
  administrator_login_password     = lookup(each.value, "administrator_login_password", null) == null ? random_password.this.result : each.value["administrator_login_password"]
  ssl_enforcement_enabled          = coalesce(lookup(each.value, "enable_ssl_enforcement"), true)
  public_network_access_enabled    = coalesce(lookup(each.value, "enable_public_network_access"), false)
  ssl_minimal_tls_version_enforced = coalesce(lookup(each.value, "ssl_minimal_tls_version_enforced"), "TLSEnforcementDisabled")

  dynamic "identity" {
    for_each = coalesce(each.value.assign_identity, false) == false ? [] : list(coalesce(each.value.assign_identity, false))
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [administrator_login_password]
  }

  tags = local.tags
}

# -
# - PostgreSQL Database
# -
resource "azurerm_postgresql_database" "this" {
  for_each            = var.postgresql_databases
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = lookup(azurerm_postgresql_server.this, each.value["server_key"], null)["name"]
  charset             = "UTF8"
  collation           = "English_United States.1252"
  depends_on          = [azurerm_postgresql_server.this]
}

# -
# - Create Key Vault Accesss Policy for PostgreSQL Server MSI
# -
locals {
  msi_enabled_servers = [
    for pg_k, pg_v in var.postgresql_servers :
    pg_v if coalesce(lookup(pg_v, "assign_identity"), false) == true
  ]

  server_principal_ids = flatten([
    for x in azurerm_postgresql_server.this :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ] if length(keys(azurerm_postgresql_server.this)) > 0
  ])

  key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get", "set", "list"]
  certificate_permissions = ["get", "create", "update", "list", "import"]
  storage_permissions     = ["get"]
}

resource "azurerm_key_vault_access_policy" "this" {
  count        = length(local.msi_enabled_servers) > 0 ? length(local.server_principal_ids) : 0
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.server_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_postgresql_server.this]
}

# -
# - Add postgreSQL Server Admin Login Password to Key Vault secrets
# - 
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.postgresql_servers
  name         = each.value["name"]
  value        = lookup(each.value, "administrator_login_password", null) == null ? random_password.this.result : each.value["administrator_login_password"]
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  depends_on   = [azurerm_postgresql_server.this]
}

# -
# - PostgreSQL Server Configurations
# -
resource "azurerm_postgresql_configuration" "this" {
  for_each            = var.postgresql_configurations
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = lookup(azurerm_postgresql_server.this, each.value["server_key"], null)["name"]
  value               = each.value["value"]
  depends_on          = [azurerm_postgresql_server.this]
}

locals {
  virtual_network_rules_list = flatten([
    for k, v in var.postgresql_servers : [
      for network in coalesce(v.allowed_networks, []) : {
        key                       = format("%s_%s", k, network.subnet_name)
        server_name               = v.name
        subnet_name               = network.subnet_name
        vnet_name                 = network.vnet_name
        networking_resource_group = network.networking_resource_group
      }
    ] if(v.enable_public_network_access == true)
  ])

  virtual_network_rules = {
    for x in local.virtual_network_rules_list : x.key => x
  }
}

# -
# - PostgreSQL Server Virtual Network Rules
# -
resource "azurerm_postgresql_virtual_network_rule" "this" {
  for_each                             = local.virtual_network_rules
  name                                 = "${each.value["server_name"]}-vnet-rule"
  resource_group_name                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name                          = each.value["server_name"]
  subnet_id                            = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]
  ignore_missing_vnet_service_endpoint = true
  depends_on                           = [azurerm_postgresql_server.this]
}

# -
# - PostgreSQL Server Firewall Rules
# -
locals {
  firewall_rules_list = flatten([
    for k, v in var.postgresql_servers : [
      for rule in coalesce(v.firewall_rules, []) : {
        key              = format("%s_%s", k, rule.name)
        name             = rule.name
        server_name      = v.name
        start_ip_address = rule.start_ip_address
        end_ip_address   = rule.end_ip_address
      }
    ] if(v.enable_public_network_access == true)
  ])

  firewall_rules = {
    for x in local.firewall_rules_list : x.key => x
  }
}

resource "azurerm_postgresql_firewall_rule" "this" {
  for_each            = local.firewall_rules
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = each.value["server_name"]
  start_ip_address    = each.value["start_ip_address"]
  end_ip_address      = each.value["end_ip_address"]
  depends_on          = [azurerm_postgresql_server.this]
}
