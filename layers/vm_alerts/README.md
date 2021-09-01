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
| [azurerm_monitor_metric_alert.vmdisktransfersdisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_metric_alert.vmlam](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_metric_alert.vmlinuxpercentusedspacedisk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_metric_alert.vmplcpu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_metric_alert.vmwam](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_metric_alert.vmwpfds](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) |
| [azurerm_monitor_scheduled_query_rules_alert.vmrwbsa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId) | Subscription within the Azure Tenant | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenantId"></a> [tenantId](#input\_tenantId) | Tenant ID of Azure Account | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vm_disktransfers_disk_alert"></a> [vm\_disktransfers\_disk\_alert](#input\_vm\_disktransfers\_disk\_alert) | Map of Azure Monitor Metric Rules Alerts Specification. | <pre>map(object({<br>    scope               = string<br>    actionGroupId       = string<br>    threshold           = number<br>  }))</pre> | <pre>{<br>  "vmdisktransfersdisk": {<br>    "actionGroupId": "full_action_group_id",<br>    "scope": "full_scope_id",<br>    "threshold": 100<br>  }<br>}</pre> | no |
| <a name="input_vm_linux_availablememory_memory_alert"></a> [vm\_linux\_availablememory\_memory\_alert](#input\_vm\_linux\_availablememory\_memory\_alert) | Map of Azure Monitor Metric Rules Alerts Specification. | <pre>map(object({<br>    scope               = string<br>    actionGroupId       = string<br>    threshold           = number<br>  }))</pre> | <pre>{<br>  "vmlam": {<br>    "actionGroupId": "full_action_group_id",<br>    "scope": "full_scope_id",<br>    "threshold": 1<br>  }<br>}</pre> | no |
| <a name="input_vm_linux_percentused_disk_alert"></a> [vm\_linux\_percentused\_disk\_alert](#input\_vm\_linux\_percentused\_disk\_alert) | Map of Azure Monitor Metric Rules Alerts Specification. | <pre>map(object({<br>    scope               = string<br>    actionGroupId       = string<br>    threshold           = number<br>  }))</pre> | <pre>{<br>  "vmlinuxpercentusedspacedisk": {<br>    "actionGroupId": "full_action_group_id",<br>    "scope": "full_scope_id",<br>    "threshold": 95<br>  }<br>}</pre> | no |
| <a name="input_vm_percentagelimit_cpu_alert"></a> [vm\_percentagelimit\_cpu\_alert](#input\_vm\_percentagelimit\_cpu\_alert) | Map of Azure Monitor Metric Rules Alerts Specification. | <pre>map(object({<br>    scope               = string<br>    actionGroupId       = string<br>    threshold           = number<br>  }))</pre> | <pre>{<br>  "vmplcpu": {<br>    "actionGroupId": "full_action_group_id",<br>    "scope": "full_scope_id",<br>    "threshold": 75<br>  }<br>}</pre> | no |
| <a name="input_vm_readwritebytespersec_network_alert"></a> [vm\_readwritebytespersec\_network\_alert](#input\_vm\_readwritebytespersec\_network\_alert) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    dataSourceId        = string<br>    actionGroupId       = string<br>  }))</pre> | <pre>{<br>  "vmrwbsa1": {<br>    "actionGroupId": "full_action_group_id",<br>    "dataSourceId": "full_data_source_id"<br>  }<br>}</pre> | no |
| <a name="input_vm_windows_availablememory_alert"></a> [vm\_windows\_availablememory\_alert](#input\_vm\_windows\_availablememory\_alert) | Map of Azure Monitor Metric Rules Alerts Specification. | <pre>map(object({<br>    scope               = string<br>    actionGroupId       = string<br>    threshold           = number<br>  }))</pre> | <pre>{<br>  "vmwam": {<br>    "actionGroupId": "full_action_group_id",<br>    "scope": "full_scope_id",<br>    "threshold": 512<br>  }<br>}</pre> | no |
| <a name="input_vm_windows_percentagefree_disk_alert"></a> [vm\_windows\_percentagefree\_disk\_alert](#input\_vm\_windows\_percentagefree\_disk\_alert) | Map of Azure Monitor Metric Rules Alerts Specification. | <pre>map(object({<br>    scope               = string<br>    actionGroupId       = string<br>    threshold           = number<br>  }))</pre> | <pre>{<br>  "vmwpfds": {<br>    "actionGroupId": "full_action_group_id",<br>    "scope": "full_scope_id",<br>    "threshold": 95<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_disktransfers_disk_alert_ids"></a> [vm\_disktransfers\_disk\_alert\_ids](#output\_vm\_disktransfers\_disk\_alert\_ids) | n/a |
| <a name="output_vm_linux_availablememory_memory_alert_ids"></a> [vm\_linux\_availablememory\_memory\_alert\_ids](#output\_vm\_linux\_availablememory\_memory\_alert\_ids) | n/a |
| <a name="output_vm_linux_percentused_disk_alert_ids"></a> [vm\_linux\_percentused\_disk\_alert\_ids](#output\_vm\_linux\_percentused\_disk\_alert\_ids) | n/a |
| <a name="output_vm_percentagelimit_cpu_alert_ids"></a> [vm\_percentagelimit\_cpu\_alert\_ids](#output\_vm\_percentagelimit\_cpu\_alert\_ids) | n/a |
| <a name="output_vm_readwritebytespersec_network_alert_ids"></a> [vm\_readwritebytespersec\_network\_alert\_ids](#output\_vm\_readwritebytespersec\_network\_alert\_ids) | n/a |
| <a name="output_vm_windows_availablememory_alert_ids"></a> [vm\_windows\_availablememory\_alert\_ids](#output\_vm\_windows\_availablememory\_alert\_ids) | n/a |
| <a name="output_vm_windows_percentagefree_disk_alert_ids"></a> [vm\_windows\_percentagefree\_disk\_alert\_ids](#output\_vm\_windows\_percentagefree\_disk\_alert\_ids) | n/a |
<!-- END_TF_DOCS -->