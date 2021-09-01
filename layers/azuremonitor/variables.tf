variable "resource_group_name" {
  type        = string
  description = " The name of the resource group in which to create the Action Group instance."
}

variable "azure_monitor_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -
# - Azure Monitor
# -
variable "action_groups" {
  type = map(object({
    name       = string
    short_name = string
    enabled    = bool
    arm_role_receivers = list(object({
      name                    = string
      role_id                 = string
      use_common_alert_schema = bool
    }))
    azure_app_push_receivers = list(object({
      name          = string
      email_address = string
    }))
    azure_function_receivers = list(object({
      name                     = string
      function_app_resource_id = string
      function_name            = string
      http_trigger_url         = string
      use_common_alert_schema  = bool
    }))
    email_receivers = list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = bool
    }))
    logic_app_receivers = list(object({
      name                    = string
      resource_id             = string
      callback_url            = string
      use_common_alert_schema = bool
    }))
    sms_receivers = list(object({
      name         = string
      country_code = string
      phone_number = string
    }))
    voice_receivers = list(object({
      name         = string
      country_code = string
      phone_number = string
    }))
    webhook_receivers = list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = bool
    }))
  }))
  description = "Map of Azure Monitor Action Groups Specification."
  default     = {}
}

variable "metric_alerts" {
  type = map(object({
    name               = string
    resource_names     = list(string)
    enabled            = bool
    description        = string
    auto_mitigate      = bool
    frequency          = string
    severity           = number
    window_size        = string
    target_resource_location = string
    target_resource_type = string
    action_group_names = list(string)
    criterias = list(object({
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = number
      dimensions = list(object({
        name     = string
        operator = string
        values   = list(string)
      }))
    }))
  }))
  description = "Map of Azure Monitor Metric Alerts Specification."
  default     = {}
}

variable "activity_log_alerts" {
  type = map(object({
    name                = string
    description         = string
    enabled             = bool
    resource_names      = list(string)
    action_group_names  = list(string)
    criterias = list(object({
      category                = string
      operation_name          = string
      resource_provider       = string
      resource_type           = string
      resource_group          = string
      resource_id             = string
      caller                  = string
      level                   = string
      status                  = string
      sub_status              = string
      recommendation_type     = string
      recommendation_category = string
      recommendation_impact   = string
    }))
  }))
  description = "Map of Azure Monitor Activity Log Alerts Specification."
  default     = {}
}

variable "log_profiles" {
  type = map(object({
    name                             = string
    locations                        = list(string)
    retention_days                   = number
    diagnostics_storage_account_name = string
  }))
  description = "Map of Azure Monitor Log Profiles Specification."
  default     = {}
}

variable "query_rules_alerts" {
  type = map(object({
    name               = string
    law_name           = string
    frequency          = number
    query              = string
    time_window        = number
    email_subject      = string
    description        = string
    enabled            = bool
    severity           = number
    throttling         = number
    action_group_names = list(string)
    trigger = object({
      operator  = string
      threshold = number
      metric_trigger = object({
        metric_column       = string
        metric_trigger_type = string
        operator            = string
        threshold           = number
      })
    })
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
