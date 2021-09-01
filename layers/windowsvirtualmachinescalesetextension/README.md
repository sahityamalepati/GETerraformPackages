<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.33.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.33.0 ~> 2.33.0 |
| <a name="provider_azurerm.ado"></a> [azurerm.ado](#provider\_azurerm.ado) | ~> 2.33.0 ~> 2.33.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_storage_account.custom_script_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine_scale_set) |
| [azurerm_virtual_machine_scale_set_extension.blob_custom_script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) |
| [azurerm_virtual_machine_scale_set_extension.custom_script](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) |
| [azurerm_virtual_machine_scale_set_extension.domain_join](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) |
| [azurerm_virtual_machine_scale_set_extension.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) |
| [azurerm_virtual_machine_scale_set_extension.run_command](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) |
| [azurerm_virtual_machine_scale_set_extension.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_scale_set_extension) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the ado subscription id | `string` | `null` | no |
| <a name="input_diagnostics_sa_name"></a> [diagnostics\_sa\_name](#input\_diagnostics\_sa\_name) | The name of diagnostics storage account | `string` | `null` | no |
| <a name="input_enable_log_analytics_extension"></a> [enable\_log\_analytics\_extension](#input\_enable\_log\_analytics\_extension) | Install LAW Extension on Windows Virtual Machine Scaleset? | `bool` | `false` | no |
| <a name="input_enable_storage_extension"></a> [enable\_storage\_extension](#input\_enable\_storage\_extension) | Install SA Extension on Windows Virtual Machine Scaleset? | `bool` | `false` | no |
| <a name="input_loganalytics_workspace_name"></a> [loganalytics\_workspace\_name](#input\_loganalytics\_workspace\_name) | The name of existing log analytics workspace to be used for diagnostic logs | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which the Windows Virtual Machine Scale Set should be exist | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_virtual_machine_scaleset_extensions"></a> [virtual\_machine\_scaleset\_extensions](#input\_virtual\_machine\_scaleset\_extensions) | Specifies the map of Windows VMSS Extensions. | <pre>map(object({<br>    virtual_machine_scaleset_name = string<br>    run_command_script_path       = string<br>    run_command_script_args       = map(string)<br>    domain_join = object({<br>      dsc_endpoint = string<br>      dsc_key      = string<br>      dsc_config   = string<br>    })<br>    custom_scripts = list(object({<br>      name                 = string<br>      command_to_execute   = string<br>      file_uris            = list(string)<br>      storage_account_name = string<br>      resource_group_name  = string<br>    }))<br>    diagnostics_storage_config_path = string<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->