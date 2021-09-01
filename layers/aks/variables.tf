variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Kubernetes Cluster."
}

variable "aks_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "aks_clusters" {
  type = map(object({
    name                            = string
    sku_tier                        = string
    dns_prefix                      = string
    kubernetes_version              = string
    docker_bridge_cidr              = string
    service_address_range           = string
    dns_ip                          = string
    rbac_enabled                    = bool
    cmk_enabled                     = bool
    assign_identity                 = bool
    admin_username                  = string
    api_server_authorized_ip_ranges = list(string)
    network_plugin                  = string
    network_policy                  = string
    pod_cidr                        = string
    managed                         = bool
    admin_group_object_ids          = list(string)
    aks_default_pool = object({
      name                      = string
      vm_size                   = string
      availability_zones        = list(string)
      enable_auto_scaling       = bool
      max_pods                  = number
      os_disk_size_gb           = number
      subnet_name               = string
      vnet_name                 = string
      networking_resource_group = string
      node_count                = number
      max_count                 = number
      min_count                 = number
    })
    auto_scaler_profile = object({
      balance_similar_node_groups      = bool
      max_graceful_termination_sec     = number
      scale_down_delay_after_add       = string
      scale_down_delay_after_delete    = string
      scale_down_delay_after_failure   = string
      scan_interval                    = string
      scale_down_unneeded              = string
      scale_down_unready               = string
      scale_down_utilization_threshold = number
    })
    load_balancer_profile = object({
      outbound_ports_allocated  = number
      idle_timeout_in_minutes   = number
      managed_outbound_ip_count = number
      outbound_ip_address_ids   = list(string)
    })
  }))
  default = {}
}

variable "aks_extra_node_pools" {
  type = map(object({
    name                      = string
    aks_key                   = string
    vm_size                   = string
    availability_zones        = list(string)
    enable_auto_scaling       = bool
    max_pods                  = number
    mode                      = string
    os_disk_size_gb           = number
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
    node_count                = number
    max_count                 = number
    min_count                 = number
  }))
  description = "(Optional) List of additional node pools"
  default     = {}
}

variable "aks_client_id" {
  type = string
}

variable "aks_client_secret" {
  type = string
}

variable "ad_enabled" {
  type        = bool
  description = "Is ad integration enabled for the following cluster"
  default     = true
}

variable "managed" {
  type        = bool
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  default     = true
}

variable "aks_client_app_id" {
  type    = string
  default = null
}

variable "aks_server_app_id" {
  type    = string
  default = null
}

variable "aks_server_app_secret" {
  type    = string
  default = null
}
variable "mgmt_key_vault_rg" {
  type    = string
  default = ""
}

variable "mgmt_key_vault_name" {
  type    = string
  default = ""
}

variable "ado_subscription_id" {
  type        = string
  description = "Specifies the ado subscription id"
}

variable "ado_subnet_name" {
  type = string
}

variable "ado_vnet_name" {
  type = string
}

variable "ado_resource_group_name" {
  type = string
}

variable "ado_aks_private_endpoint_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "acr_pe_name" {
  type = string
}

variable "acr_resource_group_name" {
  type = string
}

variable "acr_rg_location" {
  type = string
}

variable "acr_subnet_name" {
  type = string
}

variable "acr_vnet_name" {
  type = string
}

variable "pe_acr_record_name" {
  type = string
  default = null
}

variable "ado_aks_private_connection_name" {
  type = string
  default = null
}

variable "pe_kv_name" {
  type = string
  default = null
}

variable "pe_acr_vnetlink_name" {
  type = string
  default = null
}

variable "acr_private_connection_name" {
  type = string
}

variable "loganalytics_workspace_name" {
  type        = string
  description = "The Name of the existing Log Analytics Workspace which the OMS Agent should send data to."
  default     = null
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store AKS SSH Private Key."
  default     = null
}
