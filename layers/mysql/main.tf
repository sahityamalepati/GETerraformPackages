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
  count                = (var.private_endpoint_connection_enabled == false && local.networking_state_exists == false) ? length(var.allowed_networks) : 0
  name                 = element(var.allowed_networks, count.index)["subnet_name"]
  virtual_network_name = element(var.allowed_networks, count.index)["vnet_name"]
  resource_group_name  = element(var.allowed_networks, count.index)["networking_resource_group"] != null ? element(var.allowed_networks, count.index)["networking_resource_group"] : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
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
  tags                       = merge(var.mysql_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true

  administrator_login_password = var.administrator_login_password == null ? random_password.this.result : var.administrator_login_password

  key_permissions         = ["get", "wrapkey", "unwrapkey"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
  storage_permissions     = ["get"]
}

# -
# - MY SQL Server
# -
resource "azurerm_mysql_server" "this" {
  name                = var.server_name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  sku_name            = var.sku_name
  version             = var.mysql_version

  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  auto_grow_enabled            = var.auto_grow_enabled
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  create_mode                  = var.create_mode
  creation_source_server_id    = var.creation_source_server_id
  restore_point_in_time        = var.restore_point_in_time

  administrator_login               = var.administrator_login_name
  administrator_login_password      = local.administrator_login_password
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = var.ssl_minimal_tls_version
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  # - MY SQL Allow/Deny Public Network Access
  # - Only private endpoint connections will be allowed to access this resource if "private_endpoint_connection_enabled" variable is set to true
  public_network_access_enabled = var.private_endpoint_connection_enabled ? false : true

  dynamic "identity" {
    for_each = var.assign_identity == false ? [] : list(var.assign_identity)
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
# - MY SQL Databases
# -
resource "azurerm_mysql_database" "this" {
  count               = length(var.database_names)
  name                = element(var.database_names, count.index)
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = azurerm_mysql_server.this.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Configuration/Server Parameters
# -
resource "azurerm_mysql_configuration" "this" {
  for_each            = var.mysql_configurations
  name                = each.key
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = azurerm_mysql_server.this.name
  value               = each.value
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Virtual Network Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# - 
resource "azurerm_mysql_virtual_network_rule" "this" {
  count               = var.private_endpoint_connection_enabled == false ? length(var.allowed_networks) : 0
  name                = "mysql-vnet-rule-${count.index + 1}"
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = azurerm_mysql_server.this.name
  subnet_id           = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, element(var.allowed_networks, count.index)["subnet_name"]) : element(data.azurerm_subnet.this, count.index)["id"]
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - MY SQL Firewall Rule
# - Enabled only if "private_endpoint_connection_enabled" variable is set to false
# - 
resource "azurerm_mysql_firewall_rule" "this" {
  for_each            = var.private_endpoint_connection_enabled == false ? var.firewall_rules : {}
  name                = each.value.name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  server_name         = azurerm_mysql_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
  depends_on          = [azurerm_mysql_server.this]
}

# -
# - Create Key Vault Accesss Policy for MY SQL Server MSI
# -
resource "azurerm_key_vault_access_policy" "this" {
  count        = var.assign_identity == true ? 1 : 0
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_mysql_server.this.identity.0.principal_id

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_mysql_server.this]
}

# -
# - Add MY SQL Server Admin Login Password to Key Vault secrets
# - 
resource "azurerm_key_vault_secret" "this" {
  name         = azurerm_mysql_server.this.name
  value        = local.administrator_login_password
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  depends_on   = [azurerm_mysql_server.this]
}

