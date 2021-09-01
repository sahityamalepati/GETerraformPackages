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
| [azurerm_template_deployment.azgenericworkbook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_monitoring_generic_workbooks"></a> [az\_monitoring\_generic\_workbooks](#input\_az\_monitoring\_generic\_workbooks) | Generic workbook deployment template | <pre>map(object({<br>    workbookName                = string<br>    workbookDisplayName         = string<br>    workbookSourceId            = string<br>    workbookSerializedData       = string<br>  }))</pre> | <pre>{<br>  "azgenericworkbook": {<br>    "workbookDisplayName": "Workbook Display Name",<br>    "workbookName": "Workbook Name",<br>    "workbookSerializedData": "workbook Serialized Data",<br>    "workbookSourceId": "Source Id of workbook"<br>  }<br>}</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| <a name="input_subscriptionId"></a> [subscriptionId](#input\_subscriptionId) | Subscription within the Azure Tenant | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenantId"></a> [tenantId](#input\_tenantId) | Tenant ID of Azure Account | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azgenericworkbook-id1"></a> [azgenericworkbook-id1](#output\_azgenericworkbook-id1) | n/a |
<!-- END_TF_DOCS -->