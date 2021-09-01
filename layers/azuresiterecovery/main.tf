data "azurerm_resource_group" "this" {
  count                                                 = local.resourcegroup_state_exists == false ? 1 : 0
  name                                                  = var.resource_group_name
}

locals {
   tags                                                 = merge(var.rsv_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
   resourcegroup_state_exists                           = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true

  replication_policies_in_rsv = flatten([
    for rsv_k, rsv_v in var.recovery_services_vaults : [
      for replication_policy in coalesce(rsv_v["replication_policies"], []) :
      {
        key                                             = "${rsv_k}_${replication_policy.asr_replication_policy_name}"
        rsv_key                                         = rsv_k
        rsv_name                                        = rsv_v["name"]
        asr_replication_policy_name                     = replication_policy.asr_replication_policy_name
        recovery_point_retention_in_minutes             = replication_policy.recovery_point_retention_in_minutes
        application_consistent_snapshot_frequency_in_minutes = replication_policy.application_consistent_snapshot_frequency_in_minutes
      }
    ]
  ])
  replication_policies = {
    for rp in local.replication_policies_in_rsv : rp.key => rp
  }

  network_mapping_in_rsv = flatten([
    for rsv_k, rsv_v in var.recovery_services_vaults : [
      for nm in coalesce(rsv_v["network_mapping"], []) :
      {
        key                                            = "${rsv_k}_${nm.name}"
        rsv_name                                       = rsv_v["name"]
        rsv_key                                        = rsv_k
        name                                           = nm["name"]
        primary_vnet_id                                = nm["primary_vnet_id"]
        secondary_vnet_id                              = nm["secondary_vnet_id"]
      }
    ]
  ])
  network_mapping = {
    for nm_list in local.network_mapping_in_rsv : nm_list.key => nm_list
  }


  protected_items_in_rsv = flatten([
    for rsv_k, rsv_v in var.recovery_services_vaults : [
      for item in coalesce(rsv_v["protected_items"], []) :
      {
        key                                             = "${rsv_k}_${split("/", item["source_vm_id"])[8]}"
        rsv_name                                        = rsv_v["name"]
        rsv_key                                         = rsv_k
        source_vm_name                                  = split("/", item["source_vm_id"])[8]
        source_vm_id                                    = item["source_vm_id"]
        source_osdisk_id                                = item["source_osdisk_id"]
        source_datadisk_ids                             = item["source_datadisk_ids"]
        source_nic_id                                   = item["source_nic_id"]
        target_resource_group_name                      = item["target_resource_group_name"]
        target_subnet_name                              = item["target_subnet_name"]
        asr_replication_policy_name                     = item["asr_replication_policy_name"]
        target_ppg_name                                 = item["target_ppg_name"]
      } if item["cmk_disk_encryption_enabled"] == false
    ]
  ])
   protected_items = {
    for pi in local.protected_items_in_rsv : pi.key => pi if pi != []
  }



  protected_cmk_encrypted_items_in_rsv = flatten([
    for rsv_k, rsv_v in var.recovery_services_vaults : [
      for item in coalesce(rsv_v["protected_items"], []) :
      {
        key                                             = "${rsv_k}_${split("/", item["source_vm_id"])[8]}"
        rsv_name                                        = rsv_v["name"]
        rsv_key                                         = rsv_k
        source_vm_name                                  = split("/", item["source_vm_id"])[8]
        source_vm_id                                    = item["source_vm_id"]
        source_osdisk_id                                = item["source_osdisk_id"]
        source_datadisk_ids                             = item["source_datadisk_ids"]
        source_nic_id                                   = item["source_nic_id"]
        target_resource_group_name                      = item["target_resource_group_name"]
        target_subnet_name                              = item["target_subnet_name"]
        asr_replication_policy_name                     = item["asr_replication_policy_name"]
        target_disk_encryption_set_name                 = item["target_disk_encryption_set_name"]
        target_disk_encryption_set_rg_name              = item["target_disk_encryption_set_rg_name"]
        target_ppg_name                                 = item["target_ppg_name"] 
      } if item["cmk_disk_encryption_enabled"] == true
    ]
  ])
   protected_cmk_encrypted_items = {
    for pi in local.protected_cmk_encrypted_items_in_rsv : pi.key => pi if pi != []
  }

}

# -
# - Recovery Services Vault
# -
resource "azurerm_recovery_services_vault" "this" {
  for_each                                             = var.recovery_services_vaults
  name                                                 = each.value["name"]
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location                                             = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  sku                                                  = coalesce(lookup(each.value, "sku"), "Standard")
  soft_delete_enabled                                  = coalesce(lookup(each.value, "soft_delete_enabled"), true)
  tags                                                 = local.tags
}

resource "azurerm_site_recovery_replication_policy" "policy" {
  for_each                                             = local.replication_policies
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  name                                                 = each.value["asr_replication_policy_name"]
  recovery_vault_name                                  = each.value["rsv_name"]
  recovery_point_retention_in_minutes                  = each.value["recovery_point_retention_in_minutes"]
  application_consistent_snapshot_frequency_in_minutes = each.value["application_consistent_snapshot_frequency_in_minutes"]
  depends_on                                           = [azurerm_recovery_services_vault.this]
}


resource "azurerm_site_recovery_fabric" "primary" {
  for_each                                             = var.recovery_services_vaults
  name                                                 = "primary-fabric-${each.value["name"]}"
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name                                  = each.value["name"]
  location                                             = each.value["primary_region"]
  depends_on                                           = [azurerm_recovery_services_vault.this]
}

resource "azurerm_site_recovery_fabric" "secondary" {
  for_each                                             = var.recovery_services_vaults
  name                                                 = "secondary-fabric-${each.value["name"]}"
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name                                  = each.value["name"]
  location                                             = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  depends_on                                           = [azurerm_site_recovery_fabric.primary]
}

resource "azurerm_site_recovery_protection_container" "primary" {
  for_each                                             = var.recovery_services_vaults
  name                                                 = "primary-protection-container-${each.value["name"]}"
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name                                  = each.value["name"]
  recovery_fabric_name                                 = azurerm_site_recovery_fabric.primary[each.key].name
  depends_on                                           = [azurerm_site_recovery_fabric.primary, azurerm_site_recovery_fabric.secondary]
}


resource "azurerm_site_recovery_protection_container" "secondary" {
  for_each                                             = var.recovery_services_vaults
  name                                                 = "secondary-protection-container-${each.value["name"]}"
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name                                  = each.value["name"]
  recovery_fabric_name                                 = azurerm_site_recovery_fabric.secondary[each.key].name
  depends_on                                           = [azurerm_site_recovery_fabric.primary, azurerm_site_recovery_fabric.secondary]
}

resource "azurerm_site_recovery_protection_container_mapping" "container-mapping" {
  for_each                                             = local.replication_policies  
  name                                                 = "container-mapping-${each.value["key"]}"
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name                                  = each.value["rsv_name"]
  recovery_fabric_name                                 = azurerm_site_recovery_fabric.primary[each.value["rsv_key"]].name
  recovery_source_protection_container_name            = azurerm_site_recovery_protection_container.primary[each.value["rsv_key"]].name
  recovery_target_protection_container_id              = azurerm_site_recovery_protection_container.secondary[each.value["rsv_key"]].id
  recovery_replication_policy_id                       = azurerm_site_recovery_replication_policy.policy[each.key].id
  depends_on                                           = [azurerm_site_recovery_protection_container.primary, azurerm_site_recovery_protection_container.secondary, azurerm_site_recovery_replication_policy.policy]
}



resource "azurerm_site_recovery_network_mapping" "network-mapping" {
  for_each                                             = local.network_mapping 
  name                                                 = each.value["name"]
  resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name                                  = each.value["rsv_name"]
  source_recovery_fabric_name                          = azurerm_site_recovery_fabric.primary[each.value["rsv_key"]].name
  target_recovery_fabric_name                          = azurerm_site_recovery_fabric.secondary[each.value["rsv_key"]].name
  source_network_id                                    = each.value["primary_vnet_id"]
  target_network_id                                    = each.value["secondary_vnet_id"]
  depends_on                                           = [azurerm_site_recovery_protection_container_mapping.container-mapping]
}



resource "random_string" "lower" {
  for_each                                             = var.recovery_services_vaults
  length                                               = 4
  upper                                                = false
  lower                                                = true
  number                                               = true
  special                                              = false
}

#resource "azurerm_resource_group" "primary" {
#  for_each                                             = var.recovery_services_vaults 
#  name                                                 = each.value["recovery_cache_rg"]
#  location                                             = each.value["primary_region"]
#}

resource "azurerm_storage_account" "primary" {
  for_each                                             = var.recovery_services_vaults   
  name                                                 = "prireccache${random_string.lower[each.key].result}"
  location                                             = each.value["primary_region"]
  resource_group_name                                  = var.resource_group_name
  account_tier                                         = "Standard"
  account_replication_type                             = "LRS"
  depends_on                                           = [random_string.lower]
}

data "azurerm_resource_group" "target-rg" {
    for_each                                           = local.protected_items 
    name                                               = each.value["target_resource_group_name"]
}

data "azurerm_resource_group" "target-rg-cmk" {
    for_each                                           = local.protected_cmk_encrypted_items 
    name                                               = each.value["target_resource_group_name"]
}

resource "azurerm_site_recovery_replicated_vm" "this" {
   for_each                                             = local.protected_items 
   name                                                 = each.value["source_vm_name"]
   resource_group_name                                  = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
   recovery_vault_name                                  = each.value["rsv_name"]
   source_recovery_fabric_name                          = azurerm_site_recovery_fabric.primary[each.value["rsv_key"]].name
   source_vm_id                                         = each.value["source_vm_id"]
   recovery_replication_policy_id                       = azurerm_site_recovery_replication_policy.policy["${each.value["rsv_key"]}_${each.value["asr_replication_policy_name"]}"].id
   source_recovery_protection_container_name            = azurerm_site_recovery_protection_container.primary[each.value["rsv_key"]].name

   target_resource_group_id                             = data.azurerm_resource_group.target-rg[each.key].id
   target_recovery_fabric_id                            = azurerm_site_recovery_fabric.secondary[each.value["rsv_key"]].id
   target_recovery_protection_container_id              = azurerm_site_recovery_protection_container.secondary[each.value["rsv_key"]].id

   managed_disk {
      disk_id                    = each.value["source_osdisk_id"]
      staging_storage_account_id = azurerm_storage_account.primary[each.value["rsv_key"]].id
      target_resource_group_id   = data.azurerm_resource_group.target-rg[each.key].id
      target_disk_type           = "Premium_LRS"
      target_replica_disk_type   = "Premium_LRS"
   }

   dynamic "managed_disk" {
    for_each =  each.value["source_datadisk_ids"]
    content {
      disk_id                    = managed_disk.value
      staging_storage_account_id = azurerm_storage_account.primary[each.value["rsv_key"]].id
      target_resource_group_id   = data.azurerm_resource_group.target-rg[each.key].id
      target_disk_type           = "Premium_LRS"
      target_replica_disk_type   = "Premium_LRS"
    }
   }
  depends_on = [azurerm_site_recovery_network_mapping.network-mapping]
}


resource "null_resource" "PowerShellScriptRunFirstTimeOnly" {
  for_each = local.protected_cmk_encrypted_items 
  triggers = {
        trigger = "${uuid()}"
   }
  provisioner "local-exec" {
    command = "./replication.ps1 -targetResourceGroup ${each.value["target_resource_group_name"]} -targetLocation ${azurerm_recovery_services_vault.this[each.value["rsv_key"]].location} -rsvName ${each.value["rsv_name"]} -vaultRG ${var.resource_group_name} -rsvKey ${each.value["rsv_key"]} -replicationPolicyName ${each.value["asr_replication_policy_name"]} -sourceOSDiskID ${each.value["source_osdisk_id"]} -datadisks ${join(",",each.value["source_datadisk_ids"])} -vmID ${each.value["source_vm_id"]} -CachedStorageAccountId ${azurerm_storage_account.primary[each.value["rsv_key"]].id} -desName ${each.value["target_disk_encryption_set_name"]} -desRG ${each.value["target_disk_encryption_set_rg_name"]} -ppgname ${each.value["target_ppg_name"]}"
    interpreter = ["pwsh", "-Command"]     
  }
    depends_on = [azurerm_site_recovery_network_mapping.network-mapping]
}