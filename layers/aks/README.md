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
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) |
| [azurerm_key_vault.mgmtkeyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_key_vault_secret.aks_client_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.aks_server_app_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.aks_server_app_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) |
| [azurerm_private_dns_a_record.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) |
| [azurerm_private_dns_zone.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) |
| [azurerm_private_dns_zone_virtual_network_link.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) |
| [azurerm_private_endpoint.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) |
| [azurerm_resource_group.ado_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.acr_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_subnet.ado_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_subnet.default_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_subnet.extra_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_virtual_network.ado_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | n/a | `string` | n/a | yes |
| <a name="input_acr_pe_name"></a> [acr\_pe\_name](#input\_acr\_pe\_name) | n/a | `string` | n/a | yes |
| <a name="input_acr_private_connection_name"></a> [acr\_private\_connection\_name](#input\_acr\_private\_connection\_name) | n/a | `string` | n/a | yes |
| <a name="input_acr_resource_group_name"></a> [acr\_resource\_group\_name](#input\_acr\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_acr_rg_location"></a> [acr\_rg\_location](#input\_acr\_rg\_location) | n/a | `string` | n/a | yes |
| <a name="input_acr_subnet_name"></a> [acr\_subnet\_name](#input\_acr\_subnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_acr_vnet_name"></a> [acr\_vnet\_name](#input\_acr\_vnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_ad_enabled"></a> [ad\_enabled](#input\_ad\_enabled) | Is ad integration enabled for the following cluster | `bool` | `true` | no |
| <a name="input_ado_aks_private_connection_name"></a> [ado\_aks\_private\_connection\_name](#input\_ado\_aks\_private\_connection\_name) | n/a | `string` | `null` | no |
| <a name="input_ado_aks_private_endpoint_name"></a> [ado\_aks\_private\_endpoint\_name](#input\_ado\_aks\_private\_endpoint\_name) | n/a | `string` | n/a | yes |
| <a name="input_ado_resource_group_name"></a> [ado\_resource\_group\_name](#input\_ado\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_ado_subnet_name"></a> [ado\_subnet\_name](#input\_ado\_subnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the ado subscription id | `string` | n/a | yes |
| <a name="input_ado_vnet_name"></a> [ado\_vnet\_name](#input\_ado\_vnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_aks_additional_tags"></a> [aks\_additional\_tags](#input\_aks\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_aks_client_app_id"></a> [aks\_client\_app\_id](#input\_aks\_client\_app\_id) | n/a | `string` | `null` | no |
| <a name="input_aks_client_id"></a> [aks\_client\_id](#input\_aks\_client\_id) | n/a | `string` | n/a | yes |
| <a name="input_aks_client_secret"></a> [aks\_client\_secret](#input\_aks\_client\_secret) | n/a | `string` | n/a | yes |
| <a name="input_aks_clusters"></a> [aks\_clusters](#input\_aks\_clusters) | n/a | <pre>map(object({<br>    name                            = string<br>    sku_tier                        = string<br>    dns_prefix                      = string<br>    kubernetes_version              = string<br>    docker_bridge_cidr              = string<br>    service_address_range           = string<br>    dns_ip                          = string<br>    rbac_enabled                    = bool<br>    cmk_enabled                     = bool<br>    assign_identity                 = bool<br>    admin_username                  = string<br>    api_server_authorized_ip_ranges = list(string)<br>    network_plugin                  = string<br>    network_policy                  = string<br>    pod_cidr                        = string<br>    managed                         = bool<br>    admin_group_object_ids          = list(string)<br>    aks_default_pool = object({<br>      name                      = string<br>      vm_size                   = string<br>      availability_zones        = list(string)<br>      enable_auto_scaling       = bool<br>      max_pods                  = number<br>      os_disk_size_gb           = number<br>      subnet_name               = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>      node_count                = number<br>      max_count                 = number<br>      min_count                 = number<br>    })<br>    auto_scaler_profile = object({<br>      balance_similar_node_groups      = bool<br>      max_graceful_termination_sec     = number<br>      scale_down_delay_after_add       = string<br>      scale_down_delay_after_delete    = string<br>      scale_down_delay_after_failure   = string<br>      scan_interval                    = string<br>      scale_down_unneeded              = string<br>      scale_down_unready               = string<br>      scale_down_utilization_threshold = number<br>    })<br>    load_balancer_profile = object({<br>      outbound_ports_allocated  = number<br>      idle_timeout_in_minutes   = number<br>      managed_outbound_ip_count = number<br>      outbound_ip_address_ids   = list(string)<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_aks_extra_node_pools"></a> [aks\_extra\_node\_pools](#input\_aks\_extra\_node\_pools) | (Optional) List of additional node pools | <pre>map(object({<br>    name                      = string<br>    aks_key                   = string<br>    vm_size                   = string<br>    availability_zones        = list(string)<br>    enable_auto_scaling       = bool<br>    max_pods                  = number<br>    mode                      = string<br>    os_disk_size_gb           = number<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>    node_count                = number<br>    max_count                 = number<br>    min_count                 = number<br>  }))</pre> | `{}` | no |
| <a name="input_aks_server_app_id"></a> [aks\_server\_app\_id](#input\_aks\_server\_app\_id) | n/a | `string` | `null` | no |
| <a name="input_aks_server_app_secret"></a> [aks\_server\_app\_secret](#input\_aks\_server\_app\_secret) | n/a | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store AKS SSH Private Key. | `string` | `null` | no |
| <a name="input_loganalytics_workspace_name"></a> [loganalytics\_workspace\_name](#input\_loganalytics\_workspace\_name) | The Name of the existing Log Analytics Workspace which the OMS Agent should send data to. | `string` | `null` | no |
| <a name="input_managed"></a> [managed](#input\_managed) | Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration. | `bool` | `true` | no |
| <a name="input_mgmt_key_vault_name"></a> [mgmt\_key\_vault\_name](#input\_mgmt\_key\_vault\_name) | n/a | `string` | `""` | no |
| <a name="input_mgmt_key_vault_rg"></a> [mgmt\_key\_vault\_rg](#input\_mgmt\_key\_vault\_rg) | n/a | `string` | `""` | no |
| <a name="input_pe_acr_record_name"></a> [pe\_acr\_record\_name](#input\_pe\_acr\_record\_name) | n/a | `string` | `null` | no |
| <a name="input_pe_acr_vnetlink_name"></a> [pe\_acr\_vnetlink\_name](#input\_pe\_acr\_vnetlink\_name) | n/a | `string` | `null` | no |
| <a name="input_pe_kv_name"></a> [pe\_kv\_name](#input\_pe\_kv\_name) | n/a | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group in which to create the Kubernetes Cluster. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks"></a> [aks](#output\_aks) | n/a |
| <a name="output_aks_resource_ids"></a> [aks\_resource\_ids](#output\_aks\_resource\_ids) | List of Resource Id of AKS cluster's |
| <a name="output_aks_resource_ids_map"></a> [aks\_resource\_ids\_map](#output\_aks\_resource\_ids\_map) | Map of Resource Id of AKS cluster's |
<!-- END_TF_DOCS -->