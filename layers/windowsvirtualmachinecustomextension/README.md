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
| [azurerm_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine) |
| [azurerm_virtual_machine_extension.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_custom_script_extensions"></a> [custom\_script\_extensions](#input\_custom\_script\_extensions) | n/a | <pre>map(object({<br>    name                 = string<br>    virtual_machine_name = string<br>    command_to_execute   = string<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the name of the Resource Group in which the Virtual Machine should exist | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->