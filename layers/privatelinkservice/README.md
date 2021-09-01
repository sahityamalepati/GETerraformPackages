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
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb) |
| [azurerm_private_link_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_link_service) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_pls_additional_tags"></a> [pls\_additional\_tags](#input\_pls\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_private_link_services"></a> [private\_link\_services](#input\_private\_link\_services) | Map containing private link services | <pre>map(object({<br>    name                           = string       # (Required) Specifies the name of this Private Link Service.<br>    loadbalancer_name              = string       # (Optional) Specifies the name of the existing Standard Load Balancer, where traffic from the Private Link Service should be routed.<br>    frontend_ip_config_name        = string       # (Required) Frontend IP Configuration name from a Standard Load Balancer, where traffic from the Private Link Service should be routed.    <br>    subnet_name                    = string       # (Required) Specifies the name of the Subnet which should be used for the Private Link Service.<br>    vnet_name                      = string       # (Optional) Specifies the name of the existing Virtual Network which should be used for the Private Link Service.<br>    networking_resource_group      = string       # (Optional) Specifies the name of the existing Network RG which should be used for the Private Link Service.<br>    private_ip_address             = string       # (Optional) Specifies a Private Static IP Address for this IP Configuration.<br>    private_ip_address_version     = string       # (Optional) The version of the IP Protocol which should be used<br>    visibility_subscription_ids    = list(string) # (Optional) A list of Subscription UUID/GUID's that will be able to see this Private Link Service.<br>    auto_approval_subscription_ids = list(string) # (Optional) A list of Subscription UUID/GUID's that will be automatically be able to use this Private Link Service.<br>    enable_proxy_protocol          = bool         # (Optional) Should the Private Link Service support the Proxy Protocol? Defaults to false.<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the Resource Group where the Private Link Service should exist | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pls_dns_names"></a> [pls\_dns\_names](#output\_pls\_dns\_names) | A globally unique DNS Name for your Private Link Service. You can use this alias to request a connection to your Private Link Service. |
| <a name="output_pls_ids"></a> [pls\_ids](#output\_pls\_ids) | Private Link Service Id |
| <a name="output_private_link_service_map_ids"></a> [private\_link\_service\_map\_ids](#output\_private\_link\_service\_map\_ids) | n/a |
<!-- END_TF_DOCS -->