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

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) |
| [azurerm_private_endpoint_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_approval_message"></a> [approval\_message](#input\_approval\_message) | A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource | `string` | `"Please approve my private endpoint connection request"` | no |
| <a name="input_external_resource_ids"></a> [external\_resource\_ids](#input\_external\_resource\_ids) | Specifies the map of bastion/external resource ids | `map(string)` | `{}` | no |
| <a name="input_pe_additional_tags"></a> [pe\_additional\_tags](#input\_pe\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Map containing Private Endpoint and Private DNS Zone details | <pre>map(object({<br>    name                      = string<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>    resource_name             = string<br>    group_ids                 = list(string)<br>    approval_required         = bool<br>    approval_message          = string<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group name of private endpoint. If private endpoint is crated in bastion vnet then private endpoint can only be created in bastion subscription resource group | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_endpoint_ids"></a> [private\_endpoint\_ids](#output\_private\_endpoint\_ids) | Private Endpoint Id's |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | Private Endpoint IP Addresses |
| <a name="output_private_ip_addresses_map"></a> [private\_ip\_addresses\_map](#output\_private\_ip\_addresses\_map) | Map of Private Endpoint IP Addresses |
<!-- END_TF_DOCS -->