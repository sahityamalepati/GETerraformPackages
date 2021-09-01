# #############################################################################
# # OUTPUTS Recover Services Vault and Azure VM Backup Policy
# #############################################################################

output "recovery_vault_ids_map" {
  value       = { for rsv in azurerm_recovery_services_vault.this : rsv.name => rsv.id }
  description = "The Map of the Recovery Services Vault Id's."
}

output "backup_policy_ids_map" {
  value       = { for bp in azurerm_backup_policy_vm.this : bp.recovery_vault_name => bp.id }
  description = "The Map of the VM Backup Policy Id's."
}
