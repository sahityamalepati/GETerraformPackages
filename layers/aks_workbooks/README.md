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
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_template_deployment.aksnodewb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |
| [azurerm_template_deployment.aksnswb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |
| [azurerm_template_deployment.akspodwb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_node_workbooks"></a> [aks\_node\_workbooks](#input\_aks\_node\_workbooks) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>  }))</pre> | <pre>{<br>  "aksnodewb1": {<br>    "workbookDisplayName": "<workbook_display_name>",<br>    "workbookName": "<workbook_name>",<br>    "workbookSourceId": "<workbook_source_id>"<br>  }<br>}</pre> | no |
| <a name="input_aks_ns_workbooks"></a> [aks\_ns\_workbooks](#input\_aks\_ns\_workbooks) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>  }))</pre> | <pre>{<br>  "aksnswb1": {<br>    "workbookDisplayName": "<workbook_display_name>",<br>    "workbookName": "<workbook_name>",<br>    "workbookSourceId": "<workbook_source_id>"<br>  }<br>}</pre> | no |
| <a name="input_aks_pod_workbooks"></a> [aks\_pod\_workbooks](#input\_aks\_pod\_workbooks) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>  }))</pre> | <pre>{<br>  "akspodwb1": {<br>    "workbookDisplayName": "<workbook_display_name>",<br>    "workbookName": "<workbook_name>",<br>    "workbookSourceId": "<workbook_source_id>"<br>  }<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId) | Subscription within the Azure Tenant | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenantId"></a> [tenantId](#input\_tenantId) | Tenant ID of Azure Account | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_node_workbooks_ids"></a> [aks\_node\_workbooks\_ids](#output\_aks\_node\_workbooks\_ids) | n/a |
| <a name="output_aks_ns_workbooks_ids"></a> [aks\_ns\_workbooks\_ids](#output\_aks\_ns\_workbooks\_ids) | n/a |
| <a name="output_aks_pod_workbooks_ids"></a> [aks\_pod\_workbooks\_ids](#output\_aks\_pod\_workbooks\_ids) | n/a |
<!-- END_TF_DOCS -->