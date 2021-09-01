data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  for_each            = local.storage_state_exists == false ? var.log_profiles : {}
  name                = each.value["diagnostics_storage_account_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_log_analytics_workspace" "this" {
  for_each            = local.loganalytics_state_exists == false ? var.query_rules_alerts : {}
  name                = each.value["law_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

locals {
  tags                       = merge(var.azure_monitor_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  loganalytics_state_exists  = length(values(data.terraform_remote_state.loganalytics.outputs)) == 0 ? false : true

  action_group_ids_map = {
    for x in azurerm_monitor_action_group.this : x.name => x.id
  }

  metric_alert_scopes = {
    for ma_k, ma_v in var.metric_alerts :
    ma_k => [
      for resource_name in coalesce(ma_v["resource_names"], []) :
      lookup(var.resource_ids, resource_name, null)
    ]
  }

  activity_log_alert_scopes = {
    for ala_k, ala_v in var.activity_log_alerts:
    ala_k => [
      for resource_name in coalesce(ala_v["resource_names"], []) : 
      lookup(var.resource_ids, resource_name, null)
    ]
  }
}

# -
# - Manages an Action Group within Azure Monitor 
# -
resource "azurerm_monitor_action_group" "this" {
  for_each            = var.action_groups
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  short_name          = each.value["short_name"]
  enabled             = lookup(each.value, "enabled", null)

  dynamic "arm_role_receiver" {
    for_each = coalesce(lookup(each.value, "arm_role_receivers"), [])
    content {
      name                    = arm_role_receiver.value.name
      role_id                 = arm_role_receiver.value.role_id
      use_common_alert_schema = coalesce(lookup(arm_role_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "azure_app_push_receiver" {
    for_each = coalesce(lookup(each.value, "azure_app_push_receivers"), [])
    content {
      name          = azure_app_push_receiver.value.name
      email_address = azure_app_push_receiver.value.email_address
    }
  }

  dynamic "azure_function_receiver" {
    for_each = coalesce(lookup(each.value, "azure_function_receivers"), [])
    content {
      name                     = azure_function_receiver.value.name
      function_app_resource_id = azure_function_receiver.value.function_app_resource_id
      function_name            = azure_function_receiver.value.function_name
      http_trigger_url         = azure_function_receiver.value.http_trigger_url
      use_common_alert_schema  = coalesce(lookup(azure_function_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "logic_app_receiver" {
    for_each = coalesce(lookup(each.value, "logic_app_receivers"), [])
    content {
      name                    = logic_app_receiver.value.name
      resource_id             = logic_app_receiver.value.resource_id
      callback_url            = logic_app_receiver.value.callback_url
      use_common_alert_schema = coalesce(lookup(logic_app_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "email_receiver" {
    for_each = coalesce(lookup(each.value, "email_receivers"), [])
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = coalesce(lookup(email_receiver.value, "use_common_alert_schema"), true)
    }
  }

  dynamic "sms_receiver" {
    for_each = coalesce(lookup(each.value, "sms_receivers"), [])
    content {
      name         = sms_receiver.value.name
      country_code = sms_receiver.value.country_code
      phone_number = sms_receiver.value.phone_number
    }
  }

  dynamic "voice_receiver" {
    for_each = coalesce(lookup(each.value, "voice_receivers"), [])
    content {
      name         = voice_receiver.value.name
      country_code = voice_receiver.value.country_code
      phone_number = voice_receiver.value.phone_number
    }
  }

  dynamic "webhook_receiver" {
    for_each = coalesce(lookup(each.value, "webhook_receivers"), [])
    content {
      name                    = webhook_receiver.value.name
      service_uri             = webhook_receiver.value.service_uri
      use_common_alert_schema = coalesce(lookup(webhook_receiver.value, "use_common_alert_schema"), true)
    }
  }

  tags = local.tags
}

# -
# - Manages a Metric Alert within Azure Monitor
# -
resource "azurerm_monitor_metric_alert" "this" {
  for_each            = var.metric_alerts
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  scopes              = local.metric_alert_scopes[each.key]

  description   = lookup(each.value, "description", null)
  enabled       = lookup(each.value, "enabled", null)
  auto_mitigate = lookup(each.value, "auto_mitigate", null)
  frequency     = lookup(each.value, "frequency", null)
  severity      = lookup(each.value, "severity", null)
  window_size   = lookup(each.value, "window_size", null)
  target_resource_type = lookup(each.value,"target_resource_type",null)
  target_resource_location = lookup(each.value,"target_resource_location",null)

  dynamic "criteria" {
    for_each = coalesce(lookup(each.value, "criterias"), [])
    content {
      metric_namespace = lookup(criteria.value, "metric_namespace", null)
      metric_name      = lookup(criteria.value, "metric_name", null)
      aggregation      = lookup(criteria.value, "aggregation", null)
      operator         = lookup(criteria.value, "operator", null)
      threshold        = lookup(criteria.value, "threshold", null)
      dynamic "dimension" {
        for_each = coalesce(lookup(criteria.value, "dimensions", []), [])
        content {
          name     = lookup(dimension.value, "name", null)
          operator = lookup(dimension.value, "operator", null)
          values   = lookup(dimension.value, "values", null)
        }
      }
    }
  }

  dynamic "action" {
    for_each = coalesce(lookup(each.value, "action_group_names"), [])
    content {
      action_group_id = lookup(local.action_group_ids_map, action.value)
    }
  }

  tags = local.tags

  depends_on = [azurerm_monitor_action_group.this]
}

# -
# - Manages Activity Log Alerts. 
# -
resource "azurerm_monitor_activity_log_alert" "this" {
    for_each            = var.activity_log_alerts
    name                = each.value["name"]
    resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
    scopes              = local.activity_log_alert_scopes[each.key]
    description         = lookup(each.value, "description", null)
    enabled             = lookup(each.value, "enabled", null)

    dynamic "criteria" {
        for_each        = coalesce(lookup(each.value, criterias), [])
        content {
            category                = lookup(critera.value, "category", null)
            operation_name          = lookup(critera.value, "operation_name", null)
            resource_provider       = lookup(critera.value, "resource_provider", null)
            resource_type           = lookup(critera.value, "resource_type", null)
            resource_group          = lookup(critera.value, "resource_group", null)
            resource_id             = lookup(critera.value, "resource_id", null)
            caller                  = lookup(critera.value, "caller", null)
            level                   = lookup(critera.value, "level", null)
            status                  = lookup(critera.value, "status", null)
            sub_status              = lookup(critera.value, "sub_status", null)
            recommendation_type     = lookup(critera.value, "recommendation_type", null)
            recommendation_category = lookup(critera.value, "recommendation_category", null)
            recommendation_impact   = lookup(critera.value, "recommendation_impact", null)
        }
    }

    dynamic "action" {
        for_each = coalesce(lookup(each.value, "action_group_names"), [])
        content {
            action_group_id = lookup(local.action_group_ids_map, action.value)
        }
    }

    tags = local.tags
}

# -
# - Manages a Log Profile. A Log Profile configures how Activity Logs are exported
# -
resource "azurerm_monitor_log_profile" "this" {
  for_each   = var.log_profiles
  name       = each.value["name"]
  categories = ["Action", "Delete", "Write"]
  locations  = each.value["locations"]

  storage_account_id = local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.sa_ids_map, each.value["diagnostics_storage_account_name"]) : lookup(data.azurerm_storage_account.this, each.key)["id"]

  retention_policy {
    enabled = true
    days    = lookup(each.value, "retention_days", null)
  }
}

# -
# - Manages an AlertingAction Scheduled Query Rules resource within Azure Monitor.
# -
resource "azurerm_monitor_scheduled_query_rules_alert" "this" {
  for_each            = var.query_rules_alerts
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  data_source_id      = local.loganalytics_state_exists == true ? lookup(data.terraform_remote_state.loganalytics.outputs.law_id_map, each.value["law_name"]) : lookup(data.azurerm_log_analytics_workspace.this, each.key)["id"]
  frequency           = each.value["frequency"]
  query               = <<-QUERY
    ${each.value["query"]}
  QUERY
  time_window         = each.value["time_window"]

  dynamic "trigger" {
    for_each = lookup(each.value, "trigger", null) != null ? tolist([lookup(each.value, "trigger")]) : []
    content {
      operator  = lookup(trigger.value, "operator", null)
      threshold = lookup(trigger.value, "threshold", null)
      dynamic "metric_trigger" {
        for_each = lookup(trigger.value, "metric_trigger", null) != null ? tolist([lookup(trigger.value, "metric_trigger")]) : []
        content {
          metric_column       = lookup(metric_trigger.value, "metric_column", null)
          metric_trigger_type = lookup(metric_trigger.value, "metric_trigger_type", null)
          operator            = lookup(metric_trigger.value, "operator", null)
          threshold           = lookup(metric_trigger.value, "threshold", null)
        }
      }
    }
  }

  dynamic "action" {
    for_each = lookup(each.value, "action_group_names", null) != null ? [lookup(each.value, "action_group_names")] : []
    content {
      action_group = [
        for action_group_name in action.value :
        lookup(local.action_group_ids_map, action_group_name)
      ]
      email_subject = lookup(each.value, "email_subject", null)
    }
  }

  authorized_resource_ids = local.loganalytics_state_exists == true ? tolist([lookup(data.terraform_remote_state.loganalytics.outputs.law_id_map, each.value["law_name"])]) : tolist([lookup(data.azurerm_log_analytics_workspace.this, each.key)["id"]])
  description             = lookup(each.value, "description", null)
  enabled                 = coalesce(lookup(each.value, "enabled"), true)
  severity                = lookup(each.value, "severity", null)
  throttling              = lookup(each.value, "throttling", null)

  depends_on = [azurerm_monitor_action_group.this]
}
