variable "appid" {}

variable "vnet_rg_name" {}

variable "vnet_name" {}

variable "subnet_name" {}

variable "subnet_prefix" {}

variable "user_id" {}

variable "subscription_id" {}

variable "sa_principal_id" {}

variable "common_tags" {
  default = {}
}
variable "environment" {
  default = "nprd"
}

variable "resource_groups" {
  type = map(object({
    name = string
  }))
  description = ""
  default = {
    base_rg = {
      name = "devops"
    }
  }
}

variable "userID" {}

variable "region" {
  type        = string
  description = "the default azure region"
}

variable "vm_admin_username" {
  default = "adoadmin"
}
variable "vm_admin_password" {
  default = null
}
# variable "ado_url" {}

variable "vmss_agent_pools" {
  type = map(object({
    name                = string
    resource_group_name = string
    pool_name           = string # Pool name configured within Azure ADO Agent Pools. Defaults to "Default Agent Pool"
    sku                 = string # VMSS compute agent size eg. Standard_DS1_v2 Defaults to Standard_DS1_v2 
    instances           = number #(Required) The number of Virtual Machines in the Scale Set
    snet_key            = string
  }))
  description = ""
  default = null
}


# Networking

variable "virtual_networks" {
  description = "The virtal networks with their properties."
  type = map(object({
    name                = string
    address_space       = list(string)
    dns_servers         = list(string)
    resource_group_name = string
    private_dns_zones   = list(string)
  }))
  default = {
    vnet1 = {
      name                = "devops"
      address_space       = ["10.0.0.0/21"]
      dns_servers         = null
      resource_group_name = "devops"
      private_dns_zones   = []
    }
  }
}

variable "subnets" {
  description = "The virutal networks subnets with their properties."
  type = map(object({
    name              = string
    vnet_key          = string
    nsg_key           = string
    rt_key            = string
    address_prefix    = string
    pe_enable         = bool
    service_endpoints = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
  default = {
    sn0 = {
      name              = "agent_pool"
      address_prefix    = "10.0.0.0/24"
      vnet_key          = "devops"
      nsg_key           = "agent_pool"
      rt_key            = null
      pe_enable         = false
      service_endpoints = null
      delegation        = []
    },
    sn1 = {
      name              = "packer"
      address_prefix    = "10.0.2.0/28"
      vnet_key          = "devops"
      nsg_key           = "agent_pool"
      rt_key            = null
      pe_enable         = false
      service_endpoints = null
      delegation        = []
    },
    sn2 = {
      name              = "base"
      address_prefix    = "10.0.1.0/24"
      vnet_key          = "devops"
      nsg_key           = "agent_pool"
      rt_key            = null
      pe_enable         = true
      service_endpoints = null
      delegation        = []
    }
  }
}

variable "route_tables" {
  description = "The route tables with their properties."
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = bool
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
  default = {}
}

variable "network_security_groups" {
  description = "The network security groups with their properties."
  type = map(object({
    name = string
    security_rules = list(object({
      name                         = string
      description                  = string
      direction                    = string
      access                       = string
      priority                     = string
      source_address_prefix        = string
      source_address_prefixes      = list(string)
      destination_address_prefix   = string
      destination_address_prefixes = list(string)
      destination_port_range       = string
      destination_port_ranges      = list(string)
      protocol                     = string
      source_port_range            = string
      source_port_ranges           = list(string)
    }))
  }))
  default = {
  default_nsg = {
    name = "agent_pool"
    security_rules = [
      # {
      #   name                         = "allow-ado"
      #   description                  = "allows outbound traffic to ado"
      #   priority                     = 101
      #   direction                    = "Outbound"
      #   access                       = "Allow"
      #   protocol                     = "*"
      #   source_port_range            = "*"
      #   source_port_ranges           = null
      #   destination_port_range       = "*"
      #   destination_port_ranges      = null
      #   source_address_prefix        = "*"
      #   source_address_prefixes      = null
      #   destination_address_prefix   = null
      #   destination_address_prefixes = ["13.107.6.0/24","13.107.9.0/24","13.107.42.0/24","13.107.43.0/24"]
      # }
    ]
  }
}
}

variable "private_endpoints" {
  default = null
}

variable "network_ddos_protection_plan" {
  type        = string
  description = "DDOS Plan sku"
  default     = "Basic"
}

variable "net_additional_tags" {
  description = "additionla Tags"
  default     = {}
}

variable "deploy_acr" {
  default     = false
}
variable "deploy_sig" {
  default     = false
}
variable "deploy_azure_websites_dns" {
  default     = false
}

variable "acr_sku" {
  description = "Azure Container Registery sku"
  type        = string
  default     = "Premium"
}

variable acr_admin_enabled {
  description = "Azure Container Registery should a staic admin account be created"
  type        = bool
  default     = false
}

# Storage Accounts

variable storage_accounts {
  description = "A map of storage accounts to create"

  type = map(object({
    sa_name                    = string
    sa_rg_name                 = string
    sa_rg_region               = string
    sa_tier                    = string
    sa_replication_type        = string
    sa_kind                    = string
    sa_pe_is_manual_connection = bool
    sa_pe_approval_message     = string
    sa_pe_group_ids            = list(string)
    sa_pe_rg_name              = string
    sa_pe_vnet_name            = string
    sa_pe_vnet_rg_name         = string
    sa_pe_subnet_name          = string
  }))

  default = {}
}

variable storage_account_containers {
  description = "A map of storage containers to Create"
  type = map(object({
    sc_name                 = string
    sc_storage_account_name = string
  }))
  default = {}
}

# Load Balancer
variable "load_balancers" {
  type = map(object({
    name = string
    frontend_ips = list(object({
      name        = string
      subnet_name = string
      static_ip   = string
    }))
    backend_pool_names = list(string)
    add_public_ip      = bool
  }))
  description = "Map containing load balancers"
  default     = {}
}