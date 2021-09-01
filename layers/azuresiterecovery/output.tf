# #############################################################################
# # OUTPUTS Recover Services Vault and Azure VM Backup Policy
# #############################################################################

output "policies" {
  value = azurerm_site_recovery_replication_policy.policy
}

output "replicated_vms" {
  value = azurerm_site_recovery_replicated_vm.this
}

output "protected_items"{
  value = local.protected_items
}

output "protected_cmk_items"{
  value = local.protected_cmk_encrypted_items
}
