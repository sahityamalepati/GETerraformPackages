variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the App Services."
}

variable "function_app_additional_tags" {
  type        = map(string)
  description = "Additional tags for the Azure Function App resources, in addition to the resource group tags."
  default     = {}
}

# -
# - App Service Plans
# -
variable "app_service_plans" {
  type = map(object({
    name                         = string
    kind                         = string
    reserved                     = bool
    per_site_scaling             = bool
    maximum_elastic_worker_count = number
    sku_tier                     = string
    sku_size                     = string
    sku_capacity                 = number
  }))
  description = "The App Services plans with their properties."
  default     = {}
}

variable "existing_app_service_plans" {
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  description = "Existing App Services plans."
  default     = {}
}

# -
# - Azure Function Apps
# -
variable "function_apps" {
  type = map(object({
    name                    = string
    app_service_plan_key    = string
    storage_account_name    = string
    app_settings            = map(string)
    os_type                 = string
    client_affinity_enabled = bool
    enabled                 = bool
    https_only              = bool
    assign_identity         = bool
    version                 = string
    enable_monitoring       = bool
    auth_settings = object({
      enabled                        = bool
      additional_login_params        = map(string)
      allowed_external_redirect_urls = list(string)
      default_provider               = string
      issuer                         = string
      runtime_version                = string
      token_refresh_extension_hours  = number
      token_store_enabled            = bool
      unauthenticated_client_action  = string
      active_directory = object({
        #client_id         = string
        #client_secret     = string
        allowed_audiences = list(string)
      })
      microsoft = object({
        #client_id     = string
        #client_secret = string
        oauth_scopes  = list(string)
      })
    })
    connection_strings = list(object({
      name  = string
      type  = string
      value = string
    }))
    site_config = object({
      always_on                        = bool
      ftps_state                       = string
      http2_enabled                    = bool
      linux_fx_version                 = string
      linux_fx_version_local_file_path = string
      min_tls_version                  = string
      websockets_enabled               = bool
      use_32_bit_worker_process        = bool
      cors = object({
        allowed_origins     = list(string)
        support_credentials = bool
      })
      ip_restrictions = list(object({
        ip_address                = string
        virtual_network_subnet_id = string
        subnet_id                 = string
        subnet_mask               = string
        name                      = string
        priority                  = number
        action                    = string
      }))
    })
  }))
  description = "The App Services with their properties."
  default = {

  }
}

variable "application_insights_name" {
  type        = string
  description = "Specifies the Application Insights Name to collect application monitoring data"
  default     = null
}

variable "vnet_swift_connection" {
  type = map(object({
    function_app_key          = string
    subnet_name               = string
    vnet_name                 = string
    networking_resource_group = string
  }))
  description = "Map of Azure Function Virtual Network Association objects"
  default     = {}
}

variable "create_role_assignment" {
  type        = bool
  description = "Specifies whether a role assignment will be created for the Az Function Identity, if true, role_assignment_name is required"
  default     = false
}

variable "role_assignment_names" {
  type        = list(string)
  description = "The subscription role assignment name to be used for the az function identity"
  default     = []
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where CMK Keys are stored."
  default     = null
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
