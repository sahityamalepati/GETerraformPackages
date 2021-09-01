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
| [azurerm_backup_policy_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) |
| [azurerm_recovery_services_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_recovery_services_vaults"></a> [recovery\_services\_vaults](#input\_recovery\_services\_vaults) | Map of recover services vaults properties | <pre>map(object({<br>    name                = string # (Required) Specifies the name of the Recovery Services Vault.<br>    sku                 = string # (Required) Sets the vault's SKU. Possible values include: Standard, RS0.<br>    soft_delete_enabled = bool   # (Optional) Is soft delete enable for this Vault? Defaults to true.<br>    policy_name         = string<br>    backup_settings = object({<br>      frequency = string # (Required) Sets the backup frequency. Must be either Daily orWeekly.<br>      time      = string # (Required) The time of day to perform the backup in 24hour format.<br>      weekdays  = string # (Optional) The days of the week to perform backups on and weekdays should be seperated by ','(comma).<br>    })<br>    retention_settings = object({<br>      daily   = number # (Required) The number of daily backups to keep. Must be between 1 and 9999<br>      weekly  = string # count:weekdays and weekdays should be seperated by ','(comma)<br>      monthly = string # count:weekdays:weeks and weekdays & weeks should be seperated by ','(comma)<br>      yearly  = string # count:weekdays:weeks:months and weekdays, weeks & months should be seperated by ','(comma)<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Recovery Services Vault | `string` | n/a | yes |
| <a name="input_rsv_additional_tags"></a> [rsv\_additional\_tags](#input\_rsv\_additional\_tags) | Additional Recovery Services Vault resources tags, in addition to the resource group tags | `map(string)` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_policy_ids_map"></a> [backup\_policy\_ids\_map](#output\_backup\_policy\_ids\_map) | The Map of the VM Backup Policy Id's. |
| <a name="output_recovery_vault_ids_map"></a> [recovery\_vault\_ids\_map](#output\_recovery\_vault\_ids\_map) | The Map of the Recovery Services Vault Id's. |
<!-- END_TF_DOCS -->