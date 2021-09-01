<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
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
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resource groups | <pre>map(object({<br>    name     = string<br>    location = string<br>    tags     = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_ids_map"></a> [resource\_group\_ids\_map](#output\_resource\_group\_ids\_map) | The Map of the Resource Group Id's. |
| <a name="output_resource_group_locations_map"></a> [resource\_group\_locations\_map](#output\_resource\_group\_locations\_map) | The Map of the Resource Group Locations's. |
| <a name="output_resource_group_tags_map"></a> [resource\_group\_tags\_map](#output\_resource\_group\_tags\_map) | The Map of the Resource Group Tag's. |
<!-- END_TF_DOCS -->