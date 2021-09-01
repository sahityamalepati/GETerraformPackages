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
| [azurerm_template_deployment.vmssoperationswb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |
| [azurerm_template_deployment.vmwbperfanalysis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |
| [azurerm_template_deployment.vmwbperfgraph](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId) | Subscription within the Azure Tenant | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenantId"></a> [tenantId](#input\_tenantId) | Tenant ID of Azure Account | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vm_performanceanalysis_monitoring_workbooks"></a> [vm\_performanceanalysis\_monitoring\_workbooks](#input\_vm\_performanceanalysis\_monitoring\_workbooks) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>  }))</pre> | <pre>{<br>  "vmwbperfanalysis": {<br>    "workbookDisplayName": "",<br>    "workbookName": "",<br>    "workbookSourceId": ""<br>  }<br>}</pre> | no |
| <a name="input_vm_performancegraph_monitoring_workbooks"></a> [vm\_performancegraph\_monitoring\_workbooks](#input\_vm\_performancegraph\_monitoring\_workbooks) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>  }))</pre> | <pre>{<br>  "vmwbperfgraph": {<br>    "workbookDisplayName": "",<br>    "workbookName": "",<br>    "workbookSourceId": ""<br>  }<br>}</pre> | no |
| <a name="input_vm_vmssoperational_overview"></a> [vm\_vmssoperational\_overview](#input\_vm\_vmssoperational\_overview) | Map of Azure Monitor Scheduled Query Rules Alerts Specification. | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>  }))</pre> | <pre>{<br>  "vmssoperationswb": {<br>    "workbookDisplayName": "",<br>    "workbookName": "",<br>    "workbookSourceId": ""<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vmssoperationswb_ids"></a> [vmssoperationswb\_ids](#output\_vmssoperationswb\_ids) | n/a |
| <a name="output_vmwbperfanalysis_ids"></a> [vmwbperfanalysis\_ids](#output\_vmwbperfanalysis\_ids) | n/a |
| <a name="output_vmwbperfgraph_ids"></a> [vmwbperfgraph\_ids](#output\_vmwbperfgraph\_ids) | n/a |
<!-- END_TF_DOCS -->