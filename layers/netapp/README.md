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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_netapp_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_account) |
| [azurerm_netapp_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_pool) |
| [azurerm_netapp_volume.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/netapp_volume) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [null_resource.snapshot_policy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_existing_netapp_account"></a> [existing\_netapp\_account](#input\_existing\_netapp\_account) | integrating with the existing netapp resources | `string` | `null` | no |
| <a name="input_existing_netapp_account_rg_name"></a> [existing\_netapp\_account\_rg\_name](#input\_existing\_netapp\_account\_rg\_name) | integrating with the existing netapp resources | `string` | `null` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | This iterator forces the null\_resource to run again when changed | `number` | `1` | no |
| <a name="input_netapp_account"></a> [netapp\_account](#input\_netapp\_account) | NetApp Account | `string` | `null` | no |
| <a name="input_netapp_additional_tags"></a> [netapp\_additional\_tags](#input\_netapp\_additional\_tags) | Additional NetApp resources tags, in addition to the resource group tags. | `map(string)` | `{}` | no |
| <a name="input_netapp_location"></a> [netapp\_location](#input\_netapp\_location) | NetApp resources location if different than the resource group's location. | `string` | `null` | no |
| <a name="input_netapp_pools"></a> [netapp\_pools](#input\_netapp\_pools) | NetApp Pools | <pre>map(object({<br>    pool_name     = string<br>    service_level = string<br>    size_in_tb    = number<br>  }))</pre> | `{}` | no |
| <a name="input_netapp_snapshot_policies"></a> [netapp\_snapshot\_policies](#input\_netapp\_snapshot\_policies) | n/a | <pre>map(object({<br>    snapshotPolicyName = string<br>    hourlySnapshots = number<br>    dailySnapshots = number<br>    monthlySnapshots = number<br>    monthlydays = number<br>    monthlyhour = number<br>    monthlyminute = number<br>    weeklySnapshots = number<br>    enabled = bool<br>    delpolicy = number<br>  }))</pre> | n/a | yes |
| <a name="input_netapp_volumes"></a> [netapp\_volumes](#input\_netapp\_volumes) | n/a | <pre>map(object({<br>    pool_key            = string<br>    name                = string<br>    volume_path         = string<br>    service_level       = string<br>    subnet_name         = string<br>    vnet_name                      = string<br>    networking_resource_group      = string<br>    storage_quota_in_gb = number<br>    protocols           = list(string)<br>//    prevent_destroy = bool<br>    export_policy_rules = list(object({<br>      allowed_clients = list(string)<br>      nfsv3_enabled   = bool<br>      unix_read_write = bool<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the name of the resource group in which to create the Azure Network Base Infrastructure Resources. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->