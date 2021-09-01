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
| [azurerm_application_security_group.dest](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_security_group) |
| [azurerm_application_security_group.src](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_security_group) |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | The network security groups with their properties. | <pre>map(object({<br>    name                      = string<br>    tags                      = map(string)<br>//    subnet_name               = string<br>//    vnet_name                 = string<br>//    networking_resource_group = string<br>    security_rules = list(object({<br>      name                                         = string<br>      description                                  = string<br>      protocol                                     = string<br>      direction                                    = string<br>      access                                       = string<br>      priority                                     = number<br>      source_address_prefix                        = string<br>      source_address_prefixes                      = list(string)<br>      destination_address_prefix                   = string<br>      destination_address_prefixes                 = list(string)<br>      source_port_range                            = string<br>      source_port_ranges                           = list(string)<br>      destination_port_range                       = string<br>      destination_port_ranges                      = list(string)<br>      source_application_security_group_names      = list(string)<br>      destination_application_security_group_names = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_nsg_additional_tags"></a> [nsg\_additional\_tags](#input\_nsg\_additional\_tags) | Additional Network Security Group resources tags, in addition to the resource group tags. | `map(string)` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the NSGs. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_group_ids"></a> [network\_security\_group\_ids](#output\_network\_security\_group\_ids) | n/a |
| <a name="output_nsg_id_map"></a> [nsg\_id\_map](#output\_nsg\_id\_map) | n/a |
<!-- END_TF_DOCS -->