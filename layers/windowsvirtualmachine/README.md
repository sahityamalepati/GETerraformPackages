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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_availability_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) |
| [azurerm_backup_policy_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/backup_policy_vm) |
| [azurerm_backup_protected_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/disk_encryption_set) |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) |
| [azurerm_network_interface.windows_nics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) |
| [azurerm_network_interface_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) |
| [azurerm_network_interface_backend_address_pool_association.windows_nics_with_internal_backend_pools](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) |
| [azurerm_network_interface_nat_rule_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_nat_rule_association) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_role_assignment.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_virtual_machine_data_disk_attachment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) |
| [azurerm_windows_virtual_machine.windows_vms](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_administrator_user_name"></a> [administrator\_user\_name](#input\_administrator\_user\_name) | Specifies the name of the local administrator account | `string` | n/a | yes |
| <a name="input_availability_sets"></a> [availability\_sets](#input\_availability\_sets) | Map containing availability set configurations | <pre>map(object({<br>    name                         = string<br>    platform_update_domain_count = number<br>    platform_fault_domain_count  = number<br>  }))</pre> | `{}` | no |
| <a name="input_diagnostics_sa_name"></a> [diagnostics\_sa\_name](#input\_diagnostics\_sa\_name) | The name of diagnostics storage account | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store VM SSH Private Key. | `string` | `null` | no |
| <a name="input_kv_role_assignment"></a> [kv\_role\_assignment](#input\_kv\_role\_assignment) | Grant VM MSI Reader Role in KV resource? | `bool` | `false` | no |
| <a name="input_managed_data_disks"></a> [managed\_data\_disks](#input\_managed\_data\_disks) | Map containing storage data disk configurations | <pre>map(object({<br>    disk_name                 = string<br>    vm_key                    = string<br>    lun                       = string<br>    storage_account_type      = string<br>    disk_size                 = number<br>    caching                   = string<br>    write_accelerator_enabled = bool<br>    create_option             = string<br>    os_type                   = string<br>    source_resource_id        = string<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the name of the Resource Group in which the Windows Virtual Machine should exist | `string` | n/a | yes |
| <a name="input_self_role_assignment"></a> [self\_role\_assignment](#input\_self\_role\_assignment) | Grant VM MSI Reader Role in VM resource ? | `bool` | `false` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vm_additional_tags"></a> [vm\_additional\_tags](#input\_vm\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | <pre>{<br>  "monitor_enable": true<br>}</pre> | no |
| <a name="input_windows_vm_nics"></a> [windows\_vm\_nics](#input\_windows\_vm\_nics) | Map containing Windows VM NIC objects | <pre>map(object({<br>    name                           = string<br>    subnet_name                    = string<br>    vnet_name                      = string<br>    networking_resource_group      = string<br>    lb_backend_pool_names          = list(string)<br>    lb_nat_rule_names              = list(string)<br>    app_security_group_names       = list(string)<br>    app_gateway_backend_pool_names = list(string)<br>    internal_dns_name_label        = string<br>    enable_ip_forwarding           = bool<br>    enable_accelerated_networking  = bool<br>    dns_servers                    = list(string)<br>    nic_ip_configurations = list(object({<br>      name      = string<br>      static_ip = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_windows_vms"></a> [windows\_vms](#input\_windows\_vms) | Map containing Windows VM objects | <pre>map(object({<br>    name                                 = string<br>    computer_name                        = string<br>    vm_size                              = string<br>    zone                                 = string<br>    assign_identity                      = bool<br>    availability_set_key                 = string<br>    vm_nic_keys                          = list(string)<br>    source_image_reference_publisher     = string<br>    source_image_reference_offer         = string<br>    source_image_reference_sku           = string<br>    source_image_reference_version       = string<br>    os_disk_name                         = string<br>    storage_os_disk_caching              = string<br>    managed_disk_type                    = string<br>    disk_size_gb                         = number<br>    write_accelerator_enabled            = bool<br>    recovery_services_vault_name         = string<br>    vm_backup_policy_name                = string<br>    use_existing_disk_encryption_set     = bool<br>    existing_disk_encryption_set_name    = string<br>    existing_disk_encryption_set_rg_name = string<br>    enable_cmk_disk_encryption           = bool<br>    customer_managed_key_name            = string<br>    disk_encryption_set_name             = string<br>    enable_automatic_updates             = bool<br>    custom_data_path                     = string<br>    custom_data_args                     = map(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_object"></a> [vm\_object](#output\_vm\_object) | n/a |
| <a name="output_windows_vm_id_map"></a> [windows\_vm\_id\_map](#output\_windows\_vm\_id\_map) | n/a |
| <a name="output_windows_vm_identity_map"></a> [windows\_vm\_identity\_map](#output\_windows\_vm\_identity\_map) | n/a |
| <a name="output_windows_vm_ids"></a> [windows\_vm\_ids](#output\_windows\_vm\_ids) | n/a |
| <a name="output_windows_vm_names"></a> [windows\_vm\_names](#output\_windows\_vm\_names) | n/a |
| <a name="output_windows_vm_resource_group_names"></a> [windows\_vm\_resource\_group\_names](#output\_windows\_vm\_resource\_group\_names) | n/a |
| <a name="output_windows_vm_tags_map"></a> [windows\_vm\_tags\_map](#output\_windows\_vm\_tags\_map) | n/a |
<!-- END_TF_DOCS -->