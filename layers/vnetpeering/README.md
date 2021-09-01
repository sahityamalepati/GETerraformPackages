<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.20.0 ~> 2.20.0 |
| <a name="provider_azurerm.shared_subscription"></a> [azurerm.shared\_subscription](#provider\_azurerm.shared\_subscription) | ~> 2.20.0 ~> 2.20.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_virtual_network.destination](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) |
| [azurerm_virtual_network.source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) |
| [azurerm_virtual_network_peering.destination_to_source](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) |
| [azurerm_virtual_network_peering.source_to_destination](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_vnet_subscription_id"></a> [destination\_vnet\_subscription\_id](#input\_destination\_vnet\_subscription\_id) | Specifies the destination virtual network subscription id. | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vnet_peering"></a> [vnet\_peering](#input\_vnet\_peering) | Specifies the map of objects for vnet peering. | <pre>map(object({<br>    destination_vnet_name        = string<br>    destination_vnet_rg          = string<br>    source_vnet_name             = string<br>    source_vnet_rg               = string<br>    allow_forwarded_traffic      = bool<br>    allow_virtual_network_access = bool<br>    allow_gateway_transit        = bool<br>    use_remote_gateways          = bool<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_peering_dest_to_source"></a> [vnet\_peering\_dest\_to\_source](#output\_vnet\_peering\_dest\_to\_source) | n/a |
| <a name="output_vnet_peering_source_to_dest"></a> [vnet\_peering\_source\_to\_dest](#output\_vnet\_peering\_source\_to\_dest) | n/a |
<!-- END_TF_DOCS -->