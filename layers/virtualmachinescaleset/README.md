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
| <a name="provider_azurerm.ado"></a> [azurerm.ado](#provider\_azurerm.ado) | ~> 2.20.0 ~> 2.20.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/disk_encryption_set) |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) |
| [azurerm_key_vault.ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) |
| [azurerm_monitor_autoscale_setting.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) |
| [azurerm_monitor_autoscale_setting.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_autoscale_setting) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [null_resource.kv_access_policy_delay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | The Password which should be used for the local-administrator on this Virtual Machine | `string` | `null` | no |
| <a name="input_administrator_user_name"></a> [administrator\_user\_name](#input\_administrator\_user\_name) | The username of the local administrator on each Virtual Machine Scale Set instance | `string` | n/a | yes |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the Subscription Id of ADO Key Vault | `string` | `null` | no |
| <a name="input_custom_auto_scale_settings"></a> [custom\_auto\_scale\_settings](#input\_custom\_auto\_scale\_settings) | Map containing Linux VM Scaleset Auto Scale Settings objects | <pre>map(object({<br>    name              = string<br>    vmss_key          = string<br>    profile_name      = string<br>    default_instances = number<br>    minimum_instances = number<br>    maximum_instances = number<br>    rule = list(object({<br>      metric_name      = string<br>      time_grain       = string<br>      statistic        = string<br>      time_window      = string<br>      time_aggregation = string<br>      operator         = string<br>      threshold        = number<br>      direction        = string<br>      type             = string<br>      value            = string<br>      cooldown         = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_diagnostics_sa_name"></a> [diagnostics\_sa\_name](#input\_diagnostics\_sa\_name) | The name of diagnostics storage account | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store VMSS SSH Private Key. | `string` | `null` | no |
| <a name="input_kv_role_assignment"></a> [kv\_role\_assignment](#input\_kv\_role\_assignment) | Grant VMSS MSI Reader Role in KV resource? | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist | `string` | n/a | yes |
| <a name="input_ssh_key_vault_name"></a> [ssh\_key\_vault\_name](#input\_ssh\_key\_vault\_name) | Specifies the name of the Key Vault that conatins Linux VMSS SSH Keys | `string` | `null` | no |
| <a name="input_ssh_key_vault_rg_name"></a> [ssh\_key\_vault\_rg\_name](#input\_ssh\_key\_vault\_rg\_name) | Specifies the resource group name of the Key Vault that conatins Linux VMSS SSH Keys | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_virtual_machine_scalesets"></a> [virtual\_machine\_scalesets](#input\_virtual\_machine\_scalesets) | Map containing Linux VM Scaleset objects | <pre>map(object({<br>    name                                   = string<br>    vm_size                                = string<br>    zones                                  = list(string)<br>    assign_identity                        = bool<br>    subnet_name                            = string<br>    vnet_name                              = string<br>    networking_resource_group              = string<br>    app_security_group_names               = list(string)<br>    lb_backend_pool_names                  = list(string)<br>    lb_nat_pool_names                      = list(string)<br>    app_gateway_name                       = string<br>    lb_probe_name                          = string<br>    enable_rolling_upgrade                 = bool<br>    instances                              = number<br>    disable_password_authentication        = bool<br>    source_image_reference_publisher       = string<br>    source_image_reference_offer           = string<br>    source_image_reference_sku             = string<br>    source_image_reference_version         = string<br>    storage_os_disk_caching                = string<br>    managed_disk_type                      = string<br>    disk_size_gb                           = number<br>    write_accelerator_enabled              = bool<br>    use_existing_disk_encryption_set       = bool<br>    existing_disk_encryption_set_name      = string<br>    existing_disk_encryption_set_rg_name   = string<br>    enable_cmk_disk_encryption             = bool<br>    enable_default_auto_scale_settings     = bool<br>    enable_accelerated_networking          = bool<br>    use_existing_ssh_key                   = bool<br>    secret_name_of_public_ssh_key          = string<br>    enable_ip_forwarding                   = bool<br>    custom_data_path                       = string<br>    custom_data_args                       = map(string)<br>    enable_automatic_instance_repair       = bool<br>    automatic_instance_repair_grace_period = string<br>    single_placement_group                 = bool<br>    storage_profile_data_disks = list(object({<br>      lun                       = number<br>      caching                   = string<br>      disk_size_gb              = number<br>      managed_disk_type         = string<br>      write_accelerator_enabled = bool<br>    }))<br>    rolling_upgrade_policy = object({<br>      max_batch_instance_percent              = number<br>      max_unhealthy_instance_percent          = number<br>      max_unhealthy_upgraded_instance_percent = number<br>      pause_time_between_batches              = string<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_vmss_additional_tags"></a> [vmss\_additional\_tags](#input\_vmss\_additional\_tags) | Tags of the vmss in addition to the resource group tag | `map(string)` | <pre>{<br>  "monitor_enable": true<br>}</pre> | no |
| <a name="input_zones"></a> [zones](#input\_zones) | A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vmss"></a> [vmss](#output\_vmss) | n/a |
| <a name="output_vmss_id"></a> [vmss\_id](#output\_vmss\_id) | n/a |
| <a name="output_vmss_id_map"></a> [vmss\_id\_map](#output\_vmss\_id\_map) | n/a |
| <a name="output_vmss_principal_ids"></a> [vmss\_principal\_ids](#output\_vmss\_principal\_ids) | n/a |
<!-- END_TF_DOCS -->