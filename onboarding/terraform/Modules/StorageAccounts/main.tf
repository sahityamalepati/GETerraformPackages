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
}

variable containers {
  description = "A list of storage containers to Create"
  type = map(object({
    sc_name                 = string
    sc_storage_account_name = string
  }))
  default = {}
}

variable subnet_ids {
  description = "A map of subnets"
  type        = map(string)
}

variable tags {
  default = {}
}

resource random_string "sa-prefixs" {
  for_each = var.storage_accounts
  length   = 4
  upper    = false
  special  = false
  keepers = {
    sa_name_suffix = each.value["sa_name"]
    rg_name        = each.value["sa_rg_name"]
  }
}

resource "azurerm_storage_account" "storage_accounts" {
  for_each                 = var.storage_accounts
  name                     = "${each.value["sa_name"]}" #name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long
  resource_group_name      = each.value["sa_rg_name"]
  location                 = each.value["sa_rg_region"]
  account_tier             = each.value["sa_tier"]
  account_replication_type = each.value["sa_replication_type"]
  account_kind             = each.value["sa_kind"]
  min_tls_version          = "TLS1_2"
  tags                     = var.tags

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    bypass                 = ["AzureServices"]
    default_action         = "Allow"
  }

  blob_properties {
    delete_retention_policy {
      days = 30
    }
  }
}

resource "azurerm_storage_container" "storage_cnt" {
  for_each             = var.containers
  name                 = each.value["sc_name"]
  storage_account_name = each.value["sc_storage_account_name"]
  depends_on           = [azurerm_storage_account.storage_accounts]
}

locals {
  sa_pe_map = { for sa_k, sa_v in var.storage_accounts : sa_k => {
    name                 = "${azurerm_storage_account.storage_accounts[sa_k].name}-${sa_v.sa_pe_group_ids[0]}"
    approval_message     = sa_v.sa_pe_approval_message
    is_manual_connection = sa_v.sa_pe_is_manual_connection
    resource_id          = azurerm_storage_account.storage_accounts[sa_k].id
    group_ids            = sa_v.sa_pe_group_ids
    rg_name              = sa_v.sa_pe_rg_name
    rg_region            = sa_v.sa_rg_region
    subnet_id            = var.subnet_ids[sa_v.sa_pe_subnet_name]
    }
  }
}

output accounts {
  description = "A map of storage account ids"
  value = { for sa_k, sa in azurerm_storage_account.storage_accounts : sa_k => {
    name = sa.name
    id = sa.id
    primary_blob_endpoint = sa.primary_blob_endpoint }
  }
}
