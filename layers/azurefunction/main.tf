data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  for_each            = local.storage_state_exists == false ? var.function_apps : {}
  name                = each.value.storage_account_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_application_insights" "this" {
  count               = (local.appinsights_state_exists == false && var.application_insights_name != null) ? 1 : 0
  name                = var.application_insights_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? var.vnet_swift_connection : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

data "azurerm_key_vault" "this" {
  count               = local.keyvault_state_exists == false ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

data "azurerm_subscription" "this" {}

locals {
  tags                       = merge(var.function_app_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  appinsights_state_exists   = length(values(data.terraform_remote_state.applicationinsights.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true

  application_insights_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.application_insights_name != null ? (local.appinsights_state_exists == true ? lookup(data.terraform_remote_state.applicationinsights.outputs.instrumentation_key_map, var.application_insights_name, null) : data.azurerm_application_insights.this.0.instrumentation_key) : null
  }

  functions_roles_map = { for item in setproduct(var.role_assignment_names, keys(var.function_apps)) :
    "${item[0]}-${item[1]}" => {
      role     = item[0]
      function = item[1]
    }
  }
}

data "azurerm_app_service_plan" "this" {
  for_each            = var.existing_app_service_plans
  name                = each.value["name"]
  resource_group_name = lookup(each.value, "resource_group_name", local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

# -
# - App Service Plan
# -
resource "azurerm_app_service_plan" "this" {
  for_each            = var.app_service_plans
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location

  kind                         = coalesce(lookup(each.value, "kind"), "FunctionApp")
  maximum_elastic_worker_count = lookup(each.value, "maximum_elastic_worker_count", null)
  reserved                     = coalesce(lookup(each.value, "kind"), "FunctionApp") == "Linux" ? true : coalesce(lookup(each.value, "reserved"), false)
  per_site_scaling             = coalesce(lookup(each.value, "per_site_scaling"), false)

  sku {
    tier     = coalesce(each.value["sku_tier"], "Dynamic")
    size     = coalesce(each.value["sku_size"], "Y1")
    capacity = lookup(each.value, "sku_capacity", null)
  }

  lifecycle {
    ignore_changes = [kind, is_xenon]
  }

  tags = local.tags
}

# -
# - Azure Function App
# -
resource "azurerm_function_app" "this" {
  for_each                   = var.function_apps
  name                       = each.value["name"]
  location                   = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name        = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  app_service_plan_id        = lookup(merge(azurerm_app_service_plan.this, data.azurerm_app_service_plan.this), each.value["app_service_plan_key"])["id"]
  storage_account_name       = each.value["storage_account_name"]
  storage_account_access_key = local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_access_keys_map, each.value["storage_account_name"]) : lookup(data.azurerm_storage_account.this, each.key)["primary_access_key"]

  app_settings            = each.value.enable_monitoring == true ? merge(local.application_insights_settings, lookup(each.value, "app_settings", {})) : lookup(each.value, "app_settings", {})
  enabled                 = coalesce(each.value.enabled, true)
  os_type                 = lookup(each.value, "os_type", null)
  version                 = lookup(each.value, "version", null)
  https_only              = lookup(each.value, "https_only", null)
  client_affinity_enabled = lookup(each.value, "client_affinity_enabled", null)

  dynamic "auth_settings" {
    for_each = lookup(each.value, "auth_settings", null) == null ? [] : list(lookup(each.value, "auth_settings"))
    content {
      enabled                        = coalesce(lookup(auth_settings.value, "enabled"), false)
      additional_login_params        = lookup(auth_settings.value, "additional_login_params", null)
      allowed_external_redirect_urls = lookup(auth_settings.value, "allowed_external_redirect_urls", null)
      default_provider               = lookup(auth_settings.value, "default_provider", null)
      issuer                         = lookup(auth_settings.value, "issuer", "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/")
      runtime_version                = lookup(auth_settings.value, "runtime_version", null)
      token_refresh_extension_hours  = lookup(auth_settings.value, "token_refresh_extension_hours", null)
      token_store_enabled            = lookup(auth_settings.value, "token_store_enabled", null)
      unauthenticated_client_action  = lookup(auth_settings.value, "unauthenticated_client_action", null)

      dynamic "active_directory" {
        for_each = lookup(auth_settings.value, "active_directory", null) == null ? [] : list(lookup(auth_settings.value, "active_directory"))
        content {
          client_id         = lookup(data.terraform_remote_state.appregistration.outputs.application_id_map, each.value["name"], active_directory.value.client_id)
          client_secret     = lookup(active_directory.value, "client_secret", null)
          allowed_audiences = lookup(active_directory.value, "allowed_audiences", null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(auth_settings.value, "microsoft", null) == null ? [] : list(lookup(auth_settings.value, "microsoft"))
        content {
          client_id     = microsoft.value.client_id
          client_secret = microsoft.value.client_secret
          oauth_scopes  = lookup(microsoft.value, "oauth_scopes", null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = coalesce(lookup(each.value, "connection_strings"), [])
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "site_config" {
    for_each = lookup(each.value, "site_config", null) == null ? [] : list(lookup(each.value, "site_config"))
    content {
      always_on                 = lookup(merge(azurerm_app_service_plan.this, data.azurerm_app_service_plan.this), each.value["app_service_plan_key"]).sku[0].tier == "Dynamic" ? false : coalesce(site_config.value.always_on, false)
      ftps_state                = lookup(site_config.value, "ftps_state", null)
      http2_enabled             = lookup(site_config.value, "http2_enabled", null)
      linux_fx_version          = lookup(site_config.value, "linux_fx_version", null) == null ? null : lookup(site_config.value, "linux_fx_version_local_file_path", null) == null ? lookup(site_config.value, "linux_fx_version", null) : "${lookup(site_config.value, "linux_fx_version", null)}|${filebase64(lookup(site_config.value, "linux_fx_version_local_file_path", null))}" #(Optional) Linux App Framework and version for the App Service. Possible options are a Docker container (DOCKER|<user/image:tag>), a base-64 encoded Docker Compose file (COMPOSE|${filebase64("compose.yml")}) or a base-64 encoded Kubernetes Manifest (KUBE|${filebase64("kubernetes.yml")}).
      min_tls_version           = lookup(site_config.value, "min_tls_version", "1.2")                                                                                                                                                                                                                                                                                                  #(Optional) The minimum supported TLS version for the app service. Possible values are 1.0, 1.1, and 1.2. Defaults to 1.2 for new app services.
      websockets_enabled        = lookup(site_config.value, "websockets_enabled", null)                                                                                                                                                                                                                                                                                                #(Optional) Should WebSockets be enabled?
      use_32_bit_worker_process = lookup(site_config.value, "use_32_bit_worker_process", null)
      ip_restriction            = site_config.value.ip_restrictions

      dynamic "cors" {
        for_each = lookup(site_config.value, "cors", null) == null ? [] : list(lookup(site_config.value, "cors"))
        content {
          allowed_origins     = lookup(cors.value, "allowed_origins", null)
          support_credentials = lookup(cors.value, "support_credentials", null)
        }
      }
    }
  }

  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == true ? list(lookup(each.value, "assign_identity", false)) : []
    content {
      type = "SystemAssigned"
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings.WEBSITE_RUN_FROM_ZIP,
      app_settings.WEBSITE_RUN_FROM_PACKAGE,
      app_settings.MACHINEKEY_DecryptionKey,
    ]
  }

  tags = local.tags
}


# -
# - Create Key Vault Accesss Policy for AZ Function MSI
# -
locals {
  msi_enabled_functionapp_clusters = [
    for func_k, func_v in var.function_apps :
    func_v if coalesce(lookup(func_v, "assign_identity"), false) == true
  ]

  functionapp_principal_ids = flatten([
    for x in azurerm_function_app.this :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ] if length(keys(azurerm_function_app.this)) > 0
  ])

  key_permissions         = ["get", "list", "update", "create", "delete", "purge"]
  secret_permissions      = ["get", "list", "set", "delete", "purge"]
  certificate_permissions = ["get", "list", "update", "create", "delete", "purge", "import"]
  storage_permissions     = ["delete", "get", "list", "purge", "set", "update"]
}

resource "azurerm_key_vault_access_policy" "this" {
  count        = length(local.msi_enabled_functionapp_clusters) > 0 ? length(local.functionapp_principal_ids) : 0
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.functionapp_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_function_app.this]
}

# - 
# - Function App Identity Role Assignment
# -
resource "azurerm_role_assignment" "this" {
  for_each             = var.create_role_assignment == true ? local.functions_roles_map : {}
  role_definition_name = each.value.role
  principal_id         = azurerm_function_app.this[each.value.function].identity[0].principal_id
  scope                = data.azurerm_subscription.this.id
  depends_on           = [azurerm_function_app.this]
}

# - 
# - Manage Azure Function Virtual Network Association 
# -
resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  for_each       = var.vnet_swift_connection
  app_service_id = lookup(azurerm_function_app.this, each.value.function_app_key)["id"]
  subnet_id      = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]
  depends_on     = [azurerm_function_app.this]
}
