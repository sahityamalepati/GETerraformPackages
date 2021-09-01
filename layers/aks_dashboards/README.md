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
| [azurerm_dashboard.aksdash](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dashboard) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_dashboards"></a> [aks\_dashboards](#input\_aks\_dashboards) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>        dashboardName               = string<br>        workspaceName               = string<br>        workspaceResourceGroup      = string<br>        workspaceResourceId         = string<br>        nodeWorkbookName            = string<br>        podWorkbookName             = string<br>        namespaceWorkbookName       = string<br>        <br>  }))</pre> | <pre>{<br>  "aksdash1": {<br>    "dashboardName": "dashboard_name",<br>    "namespaceWorkbookName": "namespace_workbook_name",<br>    "nodeWorkbookName": "node_workbook_name",<br>    "podWorkbookName": "pod_workbook_name",<br>    "workspaceName": "workspace_name",<br>    "workspaceResourceGroup": "workspace_resource_group_name",<br>    "workspaceResourceId": "workspace_resource_id"<br>  }<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId) | Subscription within the Azure Tenant | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenantId"></a> [tenantId](#input\_tenantId) | Tenant ID of Azure Account | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_dashboard_ids"></a> [aks\_dashboard\_ids](#output\_aks\_dashboard\_ids) | n/a |
<!-- END_TF_DOCS -->