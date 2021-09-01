<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.20.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) |
| [azurerm_monitor_action_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) |
| [azurerm_monitor_activity_log_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) |
| [azurerm_monitor_log_profile.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_log_profile) |
| [azurerm_monitor_metric_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_action_groups"></a> [action\_groups](#input\_action\_groups) | Map of Azure Monitor Action Groups Specification. | <pre>map(object({<br>    name       = string<br>    short_name = string<br>    enabled    = bool<br>    arm_role_receivers = list(object({<br>      name                    = string<br>      role_id                 = string<br>      use_common_alert_schema = bool<br>    }))<br>    azure_app_push_receivers = list(object({<br>      name          = string<br>      email_address = string<br>    }))<br>    azure_function_receivers = list(object({<br>      name                     = string<br>      function_app_resource_id = string<br>      function_name            = string<br>      http_trigger_url         = string<br>      use_common_alert_schema  = bool<br>    }))<br>    email_receivers = list(object({<br>      name                    = string<br>      email_address           = string<br>      use_common_alert_schema = bool<br>    }))<br>    logic_app_receivers = list(object({<br>      name                    = string<br>      resource_id             = string<br>      callback_url            = string<br>      use_common_alert_schema = bool<br>    }))<br>    sms_receivers = list(object({<br>      name         = string<br>      country_code = string<br>      phone_number = string<br>    }))<br>    voice_receivers = list(object({<br>      name         = string<br>      country_code = string<br>      phone_number = string<br>    }))<br>    webhook_receivers = list(object({<br>      name                    = string<br>      service_uri             = string<br>      use_common_alert_schema = bool<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_activity_log_alerts"></a> [activity\_log\_alerts](#input\_activity\_log\_alerts) | Map of Azure Monitor Activity Log Alerts Specification. | <pre>map(object({<br>    name                = string<br>    description         = string<br>    enabled             = bool<br>    resource_names      = list(string)<br>    action_group_names  = list(string)<br>    criterias = list(object({<br>      category                = string<br>      operation_name          = string<br>      resource_provider       = string<br>      resource_type           = string<br>      resource_group          = string<br>      resource_id             = string<br>      caller                  = string<br>      level                   = string<br>      status                  = string<br>      sub_status              = string<br>      recommendation_type     = string<br>      recommendation_category = string<br>      recommendation_impact   = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_azure_monitor_additional_tags"></a> [azure\_monitor\_additional\_tags](#input\_azure\_monitor\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_log_profiles"></a> [log\_profiles](#input\_log\_profiles) | Map of Azure Monitor Log Profiles Specification. | <pre>map(object({<br>    name                             = string<br>    locations                        = list(string)<br>    retention_days                   = number<br>    diagnostics_storage_account_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_metric_alerts"></a> [metric\_alerts](#input\_metric\_alerts) | Map of Azure Monitor Metric Alerts Specification. | <pre>map(object({<br>    name               = string<br>    resource_names     = list(string)<br>    enabled            = bool<br>    description        = string<br>    auto_mitigate      = bool<br>    frequency          = string<br>    severity           = number<br>    window_size        = string<br>    target_resource_location = string<br>    target_resource_type = string<br>    action_group_names = list(string)<br>    criterias = list(object({<br>      metric_namespace = string<br>      metric_name      = string<br>      aggregation      = string<br>      operator         = string<br>      threshold        = number<br>      dimensions = list(object({<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_query_rules_alerts"></a> [query\_rules\_alerts](#input\_query\_rules\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    name               = string<br>    law_name           = string<br>    frequency          = number<br>    query              = string<br>    time_window        = number<br>    email_subject      = string<br>    description        = string<br>    enabled            = bool<br>    severity           = number<br>    throttling         = number<br>    action_group_names = list(string)<br>    trigger = object({<br>      operator  = string<br>      threshold = number<br>      metric_trigger = object({<br>        metric_column       = string<br>        metric_trigger_type = string<br>        operator            = string<br>        threshold           = number<br>      })<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_group_ids"></a> [action\_group\_ids](#output\_action\_group\_ids) | n/a |
| <a name="output_action_group_ids_map"></a> [action\_group\_ids\_map](#output\_action\_group\_ids\_map) | n/a |
| <a name="output_log_profile_ids"></a> [log\_profile\_ids](#output\_log\_profile\_ids) | n/a |
| <a name="output_log_profile_ids_map"></a> [log\_profile\_ids\_map](#output\_log\_profile\_ids\_map) | n/a |
| <a name="output_metric_alert_ids"></a> [metric\_alert\_ids](#output\_metric\_alert\_ids) | n/a |
| <a name="output_metric_alert_ids_map"></a> [metric\_alert\_ids\_map](#output\_metric\_alert\_ids\_map) | n/a |
| <a name="output_query_rule_alert_ids"></a> [query\_rule\_alert\_ids](#output\_query\_rule\_alert\_ids) | n/a |
| <a name="output_query_rule_alert_ids_map"></a> [query\_rule\_alert\_ids\_map](#output\_query\_rule\_alert\_ids\_map) | n/a |
<!-- END_TF_DOCS -->