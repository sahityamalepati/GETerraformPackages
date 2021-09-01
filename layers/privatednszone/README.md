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
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_dns_zone_additional_tags"></a> [dns\_zone\_additional\_tags](#input\_dns\_zone\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | Map containing Private DNS Zone Objects | <pre>map(object({<br>    dns_zone_name = string<br>    vnet_links = list(object({<br>      zone_to_vnet_link_name    = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>      zone_to_vnet_link_exists  = bool<br>    }))<br>    zone_exists          = bool<br>    registration_enabled = bool<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) resource group name of private dns zone. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_ids"></a> [dns\_zone\_ids](#output\_dns\_zone\_ids) | Prviate DNS Zone Id's |
| <a name="output_dns_zone_ids_map"></a> [dns\_zone\_ids\_map](#output\_dns\_zone\_ids\_map) | Map of Prviate DNS Zone Id's |
| <a name="output_dns_zone_vnet_link_ids"></a> [dns\_zone\_vnet\_link\_ids](#output\_dns\_zone\_vnet\_link\_ids) | Resource Id's of the Private DNS Zone Virtual Network Link |
| <a name="output_dns_zone_vnet_link_ids_map"></a> [dns\_zone\_vnet\_link\_ids\_map](#output\_dns\_zone\_vnet\_link\_ids\_map) | Map of Resource Id's of the Private DNS Zone Virtual Network Link |
<!-- END_TF_DOCS -->