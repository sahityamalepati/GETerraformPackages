<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm.ado"></a> [azurerm.ado](#provider\_azurerm.ado) | ~> 2.20.0 ~> 2.20.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_ado_pe_additional_tags"></a> [ado\_pe\_additional\_tags](#input\_ado\_pe\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_ado_private_endpoints"></a> [ado\_private\_endpoints](#input\_ado\_private\_endpoints) | Map containing Private Endpoint and Private DNS Zone details | <pre>map(object({<br>    name          = string<br>    resource_name = string<br>    group_ids     = list(string)<br>    dns_zone_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_ado_resource_group_name"></a> [ado\_resource\_group\_name](#input\_ado\_resource\_group\_name) | Specifies the existing ado agent resource group name | `string` | `null` | no |
| <a name="input_ado_subnet_name"></a> [ado\_subnet\_name](#input\_ado\_subnet\_name) | Specifies the existing ado agent subnet name | `string` | `null` | no |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the ado subscription id | `string` | `null` | no |
| <a name="input_ado_vnet_name"></a> [ado\_vnet\_name](#input\_ado\_vnet\_name) | Specifies the existing ado agent virtual network name | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_endpoint_ids"></a> [private\_endpoint\_ids](#output\_private\_endpoint\_ids) | ADO Private Endpoint Id's |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | ADO Private Endpoint IP Addresses |
| <a name="output_private_ip_addresses_map"></a> [private\_ip\_addresses\_map](#output\_private\_ip\_addresses\_map) | Map of ADO Private Endpoint IP Addresses |
<!-- END_TF_DOCS -->