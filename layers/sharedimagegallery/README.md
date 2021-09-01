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
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_shared_image_gallery.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Shared Image Gallery. | `string` | n/a | yes |
| <a name="input_shared_image_galleries"></a> [shared\_image\_galleries](#input\_shared\_image\_galleries) | Map of shared image galleries which needs to be created in a resource group | <pre>map(object({<br>    name        = string<br>    description = string<br>  }))</pre> | `{}` | no |
| <a name="input_sig_additional_tags"></a> [sig\_additional\_tags](#input\_sig\_additional\_tags) | Tags of the Shared Image Gallery in addition to the resource group tag. | `map(string)` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sig_ids"></a> [sig\_ids](#output\_sig\_ids) | n/a |
| <a name="output_sig_ids_map"></a> [sig\_ids\_map](#output\_sig\_ids\_map) | n/a |
| <a name="output_sig_names"></a> [sig\_names](#output\_sig\_names) | n/a |
| <a name="output_sig_unique_names"></a> [sig\_unique\_names](#output\_sig\_unique\_names) | n/a |
| <a name="output_sig_unique_names_map"></a> [sig\_unique\_names\_map](#output\_sig\_unique\_names\_map) | n/a |
<!-- END_TF_DOCS -->