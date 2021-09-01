<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.21.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.21.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_api_management.att-apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) |
| [azurerm_api_management_api.attdemo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management"></a> [api\_management](#input\_api\_management) | n/a | <pre>map(object({<br>    name                 = string<br>    publisher_name       = string<br>    publisher_email      = string<br>    virtual_network_type = string<br>    subnet_name          = string<br>    sku_name             = string<br>  }))</pre> | n/a | yes |
| <a name="input_apimgmtdemo"></a> [apimgmtdemo](#input\_apimgmtdemo) | n/a | <pre>map(object({<br>    name         = string<br>    apim_key     = string<br>    revision     = string<br>    display_name = string<br>    path         = string<br>    protocols    = list(string)<br>    import = object({<br>      content_format = string<br>      content_value  = string<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | n/a |
| <a name="output_apim"></a> [apim](#output\_apim) | n/a |
<!-- END_TF_DOCS -->