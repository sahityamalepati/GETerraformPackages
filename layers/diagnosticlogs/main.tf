# -
# - Access information about the Monitor Diagnostics Categories supported by Key Vault Resource.
# -
data "azurerm_monitor_diagnostic_categories" "kv_categories" {
  count       = (var.enable_kv_logs_to_log_analytics || var.enable_kv_logs_to_storage) ? 1 : 0
  resource_id = data.terraform_remote_state.keyvault.outputs.key_vault_id
}

# -
# - Setup Key Vault Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "kv_log_analytics" {
  count                      = var.enable_kv_logs_to_log_analytics ? 1 : 0
  name                       = "loganalytics-diagnostics"
  target_resource_id         = data.terraform_remote_state.keyvault.outputs.key_vault_id
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.kv_logs != null ? var.kv_logs : data.azurerm_monitor_diagnostic_categories.kv_categories.0.logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.kv_metrics != null ? var.kv_metrics : data.azurerm_monitor_diagnostic_categories.kv_categories.0.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup Key Vault Diagnostic Logging - Storage Account
# - # Design Decision #1593
# -
resource "azurerm_monitor_diagnostic_setting" "kv_storage" {
  count              = var.enable_kv_logs_to_storage ? 1 : 0
  name               = "storage-diagnostics"
  target_resource_id = data.terraform_remote_state.keyvault.outputs.key_vault_id
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.kv_logs != null ? var.kv_logs : data.azurerm_monitor_diagnostic_categories.kv_categories.0.logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.kv_metrics != null ? var.kv_metrics : data.azurerm_monitor_diagnostic_categories.kv_categories.0.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by Azure Kubernetes Cluster Resource.
# -
data "azurerm_monitor_diagnostic_categories" "aks_categories" {
  for_each    = (var.enable_aks_logs_to_log_analytics || var.enable_aks_logs_to_storage) ? data.terraform_remote_state.aks.outputs.aks_resource_ids_map : {}
  resource_id = each.value
}

# -
# - Setup Azure Kubernetes Cluster Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "aks_log_analytics" {
  for_each                   = var.enable_aks_logs_to_log_analytics ? data.terraform_remote_state.aks.outputs.aks_resource_ids_map : {}
  name                       = "loganalytics-diagnostics"
  target_resource_id         = each.value
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.aks_logs != null ? var.aks_logs : data.azurerm_monitor_diagnostic_categories.aks_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.aks_metrics != null ? var.aks_metrics : data.azurerm_monitor_diagnostic_categories.aks_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup Azure Kubernetes Cluster Diagnostic Logging - Storage Account
# -
resource "azurerm_monitor_diagnostic_setting" "aks_storage" {
  for_each           = var.enable_aks_logs_to_storage ? data.terraform_remote_state.aks.outputs.aks_resource_ids_map : {}
  name               = "storage-diagnostics"
  target_resource_id = each.value
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.aks_logs != null ? var.aks_logs : data.azurerm_monitor_diagnostic_categories.aks_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.aks_metrics != null ? var.aks_metrics : data.azurerm_monitor_diagnostic_categories.aks_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by Application Gateway Resource.
# -
data "azurerm_monitor_diagnostic_categories" "appgw_categories" {
  for_each    = (var.enable_appgw_logs_to_storage || var.enable_appgw_logs_to_log_analytics) ? data.terraform_remote_state.applicationgateway.outputs.application_gateway_ids_map : {}
  resource_id = each.value
}

# -
# - Setup Application Gateway Diagnostic Logging - Storage Account
# -
resource "azurerm_monitor_diagnostic_setting" "appgw_storage" {
  for_each           = var.enable_appgw_logs_to_storage ? data.terraform_remote_state.applicationgateway.outputs.application_gateway_ids_map : {}
  name               = "logs-storage"
  target_resource_id = each.value
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.appgw_logs != null ? var.appgw_logs : data.azurerm_monitor_diagnostic_categories.appgw_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.appgw_metrics != null ? var.appgw_metrics : data.azurerm_monitor_diagnostic_categories.appgw_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup Application Gateway Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "appgw_log_analytics" {
  for_each                   = var.enable_appgw_logs_to_log_analytics ? data.terraform_remote_state.applicationgateway.outputs.application_gateway_ids_map : {}
  name                       = "logs-log-analytics"
  target_resource_id         = each.value
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.appgw_logs != null ? var.appgw_logs : data.azurerm_monitor_diagnostic_categories.appgw_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.appgw_metrics != null ? var.appgw_metrics : data.azurerm_monitor_diagnostic_categories.appgw_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by CosmosDB Resource.
# -
data "azurerm_monitor_diagnostic_categories" "cosmosdb_categories" {
  count       = (var.enable_cosmosdb_logs_to_storage || var.enable_cosmosdb_logs_to_log_analytics) ? 1 : 0
  resource_id = data.terraform_remote_state.cosmosdb.outputs.cosmosdb_id
}

# -
# - Setup CosmosDB Diagnostic Logging - Storage Account
# -
resource "azurerm_monitor_diagnostic_setting" "cosmosdb_storage" {
  count              = var.enable_cosmosdb_logs_to_storage ? 1 : 0
  name               = "logs-storage"
  target_resource_id = data.terraform_remote_state.cosmosdb.outputs.cosmosdb_id
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.cosmosdb_logs != null ? var.cosmosdb_logs : data.azurerm_monitor_diagnostic_categories.cosmosdb_categories.0.logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.cosmosdb_metrics != null ? var.cosmosdb_metrics : data.azurerm_monitor_diagnostic_categories.cosmosdb_categories.0.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup CosmosDB Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "cosmosdb_log_analytics" {
  count                      = var.enable_cosmosdb_logs_to_log_analytics ? 1 : 0
  name                       = "logs-log-analytics"
  target_resource_id         = data.terraform_remote_state.cosmosdb.outputs.cosmosdb_id
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.cosmosdb_logs != null ? var.cosmosdb_logs : data.azurerm_monitor_diagnostic_categories.cosmosdb_categories.0.logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.cosmosdb_metrics != null ? var.cosmosdb_metrics : data.azurerm_monitor_diagnostic_categories.cosmosdb_categories.0.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by MySQL Server Resource.
# -
data "azurerm_monitor_diagnostic_categories" "mysql_categories" {
  count       = (var.enable_mysql_logs_to_storage || var.enable_mysql_logs_to_log_analytics) ? 1 : 0
  resource_id = data.terraform_remote_state.mysql.outputs.mysql_server_id
}

# -
# - Setup MySQL Server Diagnostic Logging - Storage Account
# -
resource "azurerm_monitor_diagnostic_setting" "mysql_storage" {
  count              = var.enable_mysql_logs_to_storage ? 1 : 0
  name               = "logs-storage"
  target_resource_id = data.terraform_remote_state.mysql.outputs.mysql_server_id
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.mysql_logs != null ? var.mysql_logs : data.azurerm_monitor_diagnostic_categories.mysql_categories.0.logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.mysql_metrics != null ? var.mysql_metrics : data.azurerm_monitor_diagnostic_categories.mysql_categories.0.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup MySQL Server Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "mysql_log_analytics" {
  count                      = var.enable_mysql_logs_to_log_analytics ? 1 : 0
  name                       = "logs-log-analytics"
  target_resource_id         = data.terraform_remote_state.mysql.outputs.mysql_server_id
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.mysql_logs != null ? var.mysql_logs : data.azurerm_monitor_diagnostic_categories.mysql_categories.0.logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.mysql_metrics != null ? var.mysql_metrics : data.azurerm_monitor_diagnostic_categories.mysql_categories.0.metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by Azure App Service Resource.
# -
data "azurerm_monitor_diagnostic_categories" "appservice_categories" {
  for_each    = (var.enable_appservice_logs_to_log_analytics || var.enable_appservice_logs_to_storage) ? data.terraform_remote_state.appservice.outputs.app_service_ids_map : {}
  resource_id = each.value
}

# -
# - Setup Azure App Service Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "appservice_log_analytics" {
  for_each                   = var.enable_appservice_logs_to_log_analytics ? data.terraform_remote_state.appservice.outputs.app_service_ids_map : {}
  name                       = "logs-log-analytics"
  target_resource_id         = each.value
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.appservice_logs != null ? var.appservice_logs : data.azurerm_monitor_diagnostic_categories.appservice_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.appservice_metrics != null ? var.appservice_metrics : data.azurerm_monitor_diagnostic_categories.appservice_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup Azure App Service Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "appservice_storage" {
  for_each           = var.enable_appservice_logs_to_storage ? data.terraform_remote_state.appservice.outputs.app_service_ids_map : {}
  name               = "logs-storage"
  target_resource_id = each.value
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.appservice_logs != null ? var.appservice_logs : data.azurerm_monitor_diagnostic_categories.appservice_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.appservice_metrics != null ? var.appservice_metrics : data.azurerm_monitor_diagnostic_categories.appservice_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by Azure SQL Resource.
# -
data "azurerm_monitor_diagnostic_categories" "azsql_categories" {
  for_each    = (var.enable_azsql_logs_to_log_analytics || var.enable_azsql_logs_to_storage) ? data.terraform_remote_state.azsql.outputs.azuresql_databases_ids_map : {}
  resource_id = each.value
}

# -
# - Setup Azure SQL Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "azsql_log_analytics" {
  for_each                   = var.enable_azsql_logs_to_log_analytics ? data.terraform_remote_state.azsql.outputs.azuresql_databases_ids_map : {}
  name                       = "logs-log-analytics"
  target_resource_id         = each.value
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.azsql_logs != null ? var.azsql_logs : data.azurerm_monitor_diagnostic_categories.azsql_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.azsql_metrics != null ? var.azsql_metrics : data.azurerm_monitor_diagnostic_categories.azsql_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup Azure SQL Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "azsql_storage" {
  for_each           = var.enable_azsql_logs_to_storage ? data.terraform_remote_state.azsql.outputs.azuresql_databases_ids_map : {}
  name               = "logs-storage"
  target_resource_id = each.value
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.azsql_logs != null ? var.azsql_logs : data.azurerm_monitor_diagnostic_categories.azsql_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.azsql_metrics != null ? var.azsql_metrics : data.azurerm_monitor_diagnostic_categories.azsql_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by Azure Postgre SQL Resource.
# -
data "azurerm_monitor_diagnostic_categories" "postgresql_categories" {
  for_each    = (var.enable_postgresql_logs_to_log_analytics || var.enable_postgresql_logs_to_storage) ? data.terraform_remote_state.postgresqldb.outputs.postgresql_ids_map : {}
  resource_id = each.value
}

# -
# - Setup Azure Postgre SQL Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "postgresql_log_analytics" {
  for_each                   = var.enable_postgresql_logs_to_log_analytics ? data.terraform_remote_state.postgresqldb.outputs.postgresql_ids_map : {}
  name                       = "logs-log-analytics"
  target_resource_id         = each.value
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = var.postgresql_logs != null ? var.postgresql_logs : data.azurerm_monitor_diagnostic_categories.postgresql_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.postgresql_metrics != null ? var.postgresql_metrics : data.azurerm_monitor_diagnostic_categories.postgresql_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Setup Azure Postgre SQL Diagnostic Logging - Log Analytics Workspace
# -
resource "azurerm_monitor_diagnostic_setting" "postgresql_storage" {
  for_each           = var.enable_postgresql_logs_to_storage ? data.terraform_remote_state.postgresqldb.outputs.postgresql_ids_map : {}
  name               = "logs-storage"
  target_resource_id = each.value
  storage_account_id = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)

  dynamic "log" {
    for_each = var.postgresql_logs != null ? var.postgresql_logs : data.azurerm_monitor_diagnostic_categories.postgresql_categories[each.key].logs
    content {
      category = log.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  dynamic "metric" {
    for_each = var.postgresql_metrics != null ? var.postgresql_metrics : data.azurerm_monitor_diagnostic_categories.postgresql_categories[each.key].metrics
    content {
      category = metric.value
      enabled  = true

      retention_policy {
        enabled = true
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}

# -
# - Access information about the Monitor Diagnostics Categories supported by an existing Resource.
# -
data "azurerm_monitor_diagnostic_categories" "this" {
  for_each    = var.custom_diagnostic_settings
  resource_id = each.value.resource_id
}

# -
# - Setup Custom Diagnostic Logging for Azure Resources
# -
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each           = var.custom_diagnostic_settings
  name               = each.value["name"]
  target_resource_id = each.value.resource_id

  storage_account_id         = lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, var.diagnostics_storage_account_name)
  log_analytics_workspace_id = data.terraform_remote_state.loganalytics.outputs.law_id

  dynamic "log" {
    for_each = each.value.logs != null ? each.value.logs : data.azurerm_monitor_diagnostic_categories.this[each.key].logs
    content {
      category = log.value
      enabled  = each.value.enabled

      retention_policy {
        enabled = each.value.retention_days != null ? true : false
        days    = each.value.retention_days
      }
    }
  }

  dynamic "metric" {
    for_each = each.value.metrics != null ? each.value.metrics : data.azurerm_monitor_diagnostic_categories.this[each.key].metrics
    content {
      category = metric.value
      enabled  = each.value.enabled

      retention_policy {
        enabled = each.value.retention_days != null ? true : false
        days    = each.value.retention_days
      }
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}
