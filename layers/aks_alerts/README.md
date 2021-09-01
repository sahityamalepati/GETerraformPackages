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
| [azurerm_monitor_scheduled_query_rules_alert.ancla](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.anmla](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.ansla](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.apcla](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.apmla](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.apnra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.apra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_resource_group.aks_alerts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_node_cpu_limit_alerts"></a> [aks\_node\_cpu\_limit\_alerts](#input\_aks\_node\_cpu\_limit\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    cpuThreshold        = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "ancla1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "cpuThreshold": 90,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "severity": 3,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_aks_node_memory_limit_alerts"></a> [aks\_node\_memory\_limit\_alerts](#input\_aks\_node\_memory\_limit\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    memThreshold        = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "anmla1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "memThreshold": 90,<br>    "severity": 3,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_aks_node_storage_limit_alerts"></a> [aks\_node\_storage\_limit\_alerts](#input\_aks\_node\_storage\_limit\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    storageThreshold    = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "ansla1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "severity": 3,<br>    "storageThreshold": 90,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_aks_pod_cpu_limit_alerts"></a> [aks\_pod\_cpu\_limit\_alerts](#input\_aks\_pod\_cpu\_limit\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    cpuThreshold        = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "apcla1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "cpuThreshold": 90,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "severity": 3,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_aks_pod_mem_limit_alerts"></a> [aks\_pod\_mem\_limit\_alerts](#input\_aks\_pod\_mem\_limit\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    memThreshold        = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "apmla1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "memThreshold": 90,<br>    "severity": 3,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_aks_pod_not_ready_alerts"></a> [aks\_pod\_not\_ready\_alerts](#input\_aks\_pod\_not\_ready\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    pendingThreshold    = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "apnra1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "pendingThreshold": 1,<br>    "severity": 3,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_aks_pod_restart_alerts"></a> [aks\_pod\_restart\_alerts](#input\_aks\_pod\_restart\_alerts) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    clusterName         = string<br>    dataSourceId        = string<br>    actionGroupId       = string<br>    frequency           = number<br>    time_window         = number<br>    severity            = number<br>    restartThreshold    = number<br>    countThreshold      = number<br>  }))</pre> | <pre>{<br>  "apra1": {<br>    "actionGroupId": "full_actionGroup_id",<br>    "clusterName": "cluster_name",<br>    "countThreshold": 3,<br>    "dataSourceId": "full_dataSource_id",<br>    "frequency": 5,<br>    "restartThreshold": 1,<br>    "severity": 3,<br>    "time_window": 30<br>  }<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId) | Subscription within the Azure Tenant | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenantId"></a> [tenantId](#input\_tenantId) | Tenant ID of Azure Account | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_node_cpu_limit_alerts_ids"></a> [aks\_node\_cpu\_limit\_alerts\_ids](#output\_aks\_node\_cpu\_limit\_alerts\_ids) | n/a |
| <a name="output_aks_node_memory_limit_alerts_ids"></a> [aks\_node\_memory\_limit\_alerts\_ids](#output\_aks\_node\_memory\_limit\_alerts\_ids) | n/a |
| <a name="output_aks_node_storage_limit_alerts_ids"></a> [aks\_node\_storage\_limit\_alerts\_ids](#output\_aks\_node\_storage\_limit\_alerts\_ids) | n/a |
| <a name="output_aks_pod_cpu_limit_alerts_ids"></a> [aks\_pod\_cpu\_limit\_alerts\_ids](#output\_aks\_pod\_cpu\_limit\_alerts\_ids) | n/a |
| <a name="output_aks_pod_mem_limit_alerts_ids"></a> [aks\_pod\_mem\_limit\_alerts\_ids](#output\_aks\_pod\_mem\_limit\_alerts\_ids) | n/a |
| <a name="output_aks_pod_not_ready_alerts_ids"></a> [aks\_pod\_not\_ready\_alerts\_ids](#output\_aks\_pod\_not\_ready\_alerts\_ids) | n/a |
| <a name="output_aks_pod_restart_alerts_ids"></a> [aks\_pod\_restart\_alerts\_ids](#output\_aks\_pod\_restart\_alerts\_ids) | n/a |
<!-- END_TF_DOCS -->