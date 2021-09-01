<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.33.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_monitor_autoscale_setting.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) |
| [azurerm_monitor_autoscale_setting.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_windows_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine_scale_set) |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_administrator_user_name"></a> [administrator\_user\_name](#input\_administrator\_user\_name) | The username of the local administrator on each Virtual Machine Scale Set instance | `string` | n/a | yes |
| <a name="input_custom_auto_scale_settings"></a> [custom\_auto\_scale\_settings](#input\_custom\_auto\_scale\_settings) | Map containing Windows VM Scaleset Auto Scale Settings objects | <pre>map(object({<br>    name              = string<br>    vmss_key          = string<br>    profile_name      = string<br>    default_instances = number<br>    minimum_instances = number<br>    maximum_instances = number<br>    rule = list(object({<br>      metric_name      = string<br>      time_grain       = string<br>      statistic        = string<br>      time_window      = string<br>      time_aggregation = string<br>      operator         = string<br>      threshold        = number<br>      direction        = string<br>      type             = string<br>      value            = string<br>      cooldown         = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_diagnostics_sa_name"></a> [diagnostics\_sa\_name](#input\_diagnostics\_sa\_name) | The name of diagnostics storage account | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store VMSS SSH Private Key. | `string` | `null` | no |
| <a name="input_kv_role_assignment"></a> [kv\_role\_assignment](#input\_kv\_role\_assignment) | Grant VMSS MSI Reader Role in KV resource? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which the Windows Virtual Machine Scale Set should be exist | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_virtual_machine_scalesets"></a> [virtual\_machine\_scalesets](#input\_virtual\_machine\_scalesets) | Map containing Windows VM Scaleset objects | <pre>map(object({<br>    name                                   = string<br>    computer_name_prefix                   = string<br>    vm_size                                = string<br>    zones                                  = list(string)<br>    assign_identity                        = bool<br>    instances                              = number<br>    networking_resource_group              = string<br>    subnet_name                            = string<br>    vnet_name                              = string<br>    app_security_group_names               = list(string)<br>    lb_backend_pool_names                  = list(string)<br>    lb_nat_pool_names                      = list(string)<br>    app_gateway_name                       = string<br>    lb_probe_name                          = string<br>    source_image_reference_publisher       = string<br>    source_image_reference_offer           = string<br>    source_image_reference_sku             = string<br>    source_image_reference_version         = string<br>    storage_os_disk_caching                = string<br>    managed_disk_type                      = string<br>    disk_size_gb                           = number<br>    write_accelerator_enabled              = bool<br>    upgrade_mode                           = string<br>    enable_automatic_os_upgrade            = bool<br>    enable_cmk_disk_encryption             = bool<br>    enable_accelerated_networking          = bool<br>    enable_ip_forwarding                   = bool<br>    enable_automatic_instance_repair       = bool<br>    automatic_instance_repair_grace_period = string<br>    enable_default_auto_scale_settings     = bool<br>    enable_automatic_updates               = bool<br>    ultra_ssd_enabled                      = bool<br>    custom_data_path                       = string<br>    custom_data_args                       = map(string)<br>    storage_profile_data_disks = list(object({<br>      lun                       = number<br>      caching                   = string<br>      disk_size_gb              = number<br>      managed_disk_type         = string<br>      write_accelerator_enabled = bool<br>    }))<br>    rolling_upgrade_policy = object({<br>      max_batch_instance_percent              = number<br>      max_unhealthy_instance_percent          = number<br>      max_unhealthy_upgraded_instance_percent = number<br>      pause_time_between_batches              = string<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_vmss_additional_tags"></a> [vmss\_additional\_tags](#input\_vmss\_additional\_tags) | Tags of the vmss in addition to the resource group tag | `map(string)` | <pre>{<br>  "monitor_enable": true<br>}</pre> | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_windows_vmss"></a> [windows\_vmss](#output\_windows\_vmss) | n/a |
| <a name="output_windows_vmss_id"></a> [windows\_vmss\_id](#output\_windows\_vmss\_id) | n/a |
| <a name="output_windows_vmss_id_map"></a> [windows\_vmss\_id\_map](#output\_windows\_vmss\_id\_map) | n/a |
| <a name="output_windows_vmss_principal_ids"></a> [windows\_vmss\_principal\_ids](#output\_windows\_vmss\_principal\_ids) | n/a |
<!-- END_TF_DOCS -->