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
| [azurerm_monitor_diagnostic_categories.aks_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.appgw_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.appservice_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.azsql_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.cosmosdb_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.kv_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.mysql_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.postgresql_categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_categories.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) |
| [azurerm_monitor_diagnostic_setting.aks_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.aks_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.appgw_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.appgw_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.appservice_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.appservice_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.azsql_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.azsql_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.cosmosdb_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.cosmosdb_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.kv_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.kv_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.mysql_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.mysql_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.postgresql_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.postgresql_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_logs"></a> [aks\_logs](#input\_aks\_logs) | List of log categories for AKS Cluster Resource. | `list(string)` | `null` | no |
| <a name="input_aks_metrics"></a> [aks\_metrics](#input\_aks\_metrics) | List of metric categories for AKS Cluster Resource. | `list(string)` | `null` | no |
| <a name="input_appgw_logs"></a> [appgw\_logs](#input\_appgw\_logs) | List of log categories for Application Gateway Resource. | `list(string)` | `null` | no |
| <a name="input_appgw_metrics"></a> [appgw\_metrics](#input\_appgw\_metrics) | List of metric categories for Application Gateway Resource. | `list(string)` | `null` | no |
| <a name="input_appservice_logs"></a> [appservice\_logs](#input\_appservice\_logs) | List of log categories for Azure App Service Resource. | `list(string)` | `null` | no |
| <a name="input_appservice_metrics"></a> [appservice\_metrics](#input\_appservice\_metrics) | List of metric categories for Azure App Service Resource. | `list(string)` | `null` | no |
| <a name="input_azsql_logs"></a> [azsql\_logs](#input\_azsql\_logs) | List of log categories for Azure SQL Resource. | `list(string)` | `null` | no |
| <a name="input_azsql_metrics"></a> [azsql\_metrics](#input\_azsql\_metrics) | List of metric categories for Azure SQL Resource. | `list(string)` | `null` | no |
| <a name="input_cosmosdb_logs"></a> [cosmosdb\_logs](#input\_cosmosdb\_logs) | List of log categories for CosmosDB Resource. | `list(string)` | `null` | no |
| <a name="input_cosmosdb_metrics"></a> [cosmosdb\_metrics](#input\_cosmosdb\_metrics) | List of metric categories for CosmosDB Resource. | `list(string)` | `null` | no |
| <a name="input_custom_diagnostic_settings"></a> [custom\_diagnostic\_settings](#input\_custom\_diagnostic\_settings) | Map of custom diagnostic log settings for azure resources. | <pre>map(object({<br>    name           = string       # The name of the diagnostic setting.<br>    resource_id    = string       # The ID of the resource.<br>    enabled        = bool         # Either `true` to enable diagnostic settings or `false` to disable it.<br>    retention_days = number       # The number of days to keep diagnostic logs<br>    logs           = list(string) # List of log categories.<br>    metrics        = list(string) # List of metric categories.<br>  }))</pre> | `{}` | no |
| <a name="input_diagnostics_storage_account_name"></a> [diagnostics\_storage\_account\_name](#input\_diagnostics\_storage\_account\_name) | Specifies the name of the Storage Account where Diagnostics Data should be sent | `string` | `null` | no |
| <a name="input_enable_aks_logs_to_log_analytics"></a> [enable\_aks\_logs\_to\_log\_analytics](#input\_enable\_aks\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for AKS Cluster resource | `bool` | `false` | no |
| <a name="input_enable_aks_logs_to_storage"></a> [enable\_aks\_logs\_to\_storage](#input\_enable\_aks\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for AKS Cluster resource | `bool` | `false` | no |
| <a name="input_enable_appgw_logs_to_log_analytics"></a> [enable\_appgw\_logs\_to\_log\_analytics](#input\_enable\_appgw\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for Application Gateway resource | `bool` | `false` | no |
| <a name="input_enable_appgw_logs_to_storage"></a> [enable\_appgw\_logs\_to\_storage](#input\_enable\_appgw\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for Application Gateway resource | `bool` | `false` | no |
| <a name="input_enable_appservice_logs_to_log_analytics"></a> [enable\_appservice\_logs\_to\_log\_analytics](#input\_enable\_appservice\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for Azure App Service resource | `bool` | `false` | no |
| <a name="input_enable_appservice_logs_to_storage"></a> [enable\_appservice\_logs\_to\_storage](#input\_enable\_appservice\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for Azure App Service resource | `bool` | `false` | no |
| <a name="input_enable_azsql_logs_to_log_analytics"></a> [enable\_azsql\_logs\_to\_log\_analytics](#input\_enable\_azsql\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for Azure SQL resource | `bool` | `false` | no |
| <a name="input_enable_azsql_logs_to_storage"></a> [enable\_azsql\_logs\_to\_storage](#input\_enable\_azsql\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for Azure SQL resource | `bool` | `false` | no |
| <a name="input_enable_cosmosdb_logs_to_log_analytics"></a> [enable\_cosmosdb\_logs\_to\_log\_analytics](#input\_enable\_cosmosdb\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for CosmosDB resource | `bool` | `false` | no |
| <a name="input_enable_cosmosdb_logs_to_storage"></a> [enable\_cosmosdb\_logs\_to\_storage](#input\_enable\_cosmosdb\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for CosmosDB resource | `bool` | `false` | no |
| <a name="input_enable_kv_logs_to_log_analytics"></a> [enable\_kv\_logs\_to\_log\_analytics](#input\_enable\_kv\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for Key Vault resource | `bool` | `false` | no |
| <a name="input_enable_kv_logs_to_storage"></a> [enable\_kv\_logs\_to\_storage](#input\_enable\_kv\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for Key Vault resource | `bool` | `false` | no |
| <a name="input_enable_mysql_logs_to_log_analytics"></a> [enable\_mysql\_logs\_to\_log\_analytics](#input\_enable\_mysql\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for MySQL Server resource | `bool` | `false` | no |
| <a name="input_enable_mysql_logs_to_storage"></a> [enable\_mysql\_logs\_to\_storage](#input\_enable\_mysql\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for MySQL Server resource | `bool` | `false` | no |
| <a name="input_enable_postgresql_logs_to_log_analytics"></a> [enable\_postgresql\_logs\_to\_log\_analytics](#input\_enable\_postgresql\_logs\_to\_log\_analytics) | Boolean flag to specify whether the logs should be sent to Log Analytics for Postgre SQL resource | `bool` | `false` | no |
| <a name="input_enable_postgresql_logs_to_storage"></a> [enable\_postgresql\_logs\_to\_storage](#input\_enable\_postgresql\_logs\_to\_storage) | Boolean flag to specify whether the logs should be sent to the Storage Account for Postgre SQL resource | `bool` | `false` | no |
| <a name="input_kv_logs"></a> [kv\_logs](#input\_kv\_logs) | List of log categories for Key Vault Resource. | `list(string)` | `null` | no |
| <a name="input_kv_metrics"></a> [kv\_metrics](#input\_kv\_metrics) | List of metric categories for Key Vault Resource. | `list(string)` | `null` | no |
| <a name="input_mysql_logs"></a> [mysql\_logs](#input\_mysql\_logs) | List of log categories for MySQL Server Resource. | `list(string)` | `null` | no |
| <a name="input_mysql_metrics"></a> [mysql\_metrics](#input\_mysql\_metrics) | List of metric categories for MySQL Server Resource. | `list(string)` | `null` | no |
| <a name="input_postgresql_logs"></a> [postgresql\_logs](#input\_postgresql\_logs) | List of log categories for Postgre SQL Resource. | `list(string)` | `null` | no |
| <a name="input_postgresql_metrics"></a> [postgresql\_metrics](#input\_postgresql\_metrics) | List of metric categories for Postgre SQL Resource. | `list(string)` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kv_log_analytics_diagnostic_logs"></a> [kv\_log\_analytics\_diagnostic\_logs](#output\_kv\_log\_analytics\_diagnostic\_logs) | Log analytics diagnostic logs |
| <a name="output_kv_storage_diagnostic_logs"></a> [kv\_storage\_diagnostic\_logs](#output\_kv\_storage\_diagnostic\_logs) | Storage diagnostic logs |
<!-- END_TF_DOCS -->