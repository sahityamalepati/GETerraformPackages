##
# With Azure Container Networking Interface (CNI), every pod gets an IP address from the subnet and can be accessed directly.   
# The service principal used by the AKS cluster must have at least Network Contributor permissions on the subnet within your virtual network.
##
# resource "azurerm_role_assignment" "aks_network" {
#   for_each             = var.aks_clusters
#   scope                = lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_ids_map, var.resource_group_name)
#   role_definition_name = "Network Contributor"
#   principal_id         = azurerm_kubernetes_cluster.this["aks1"].identity[0].principal_id
# }

# resource "azurerm_role_assignment" "aks_acr" {
#   for_each             = var.aks_clusters
#   scope                = data.azurerm_container_registry.acr.id # Required for advanced networking
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.this["aks1"].kubelet_identity[0].object_id
# }

# resource "azurerm_role_assignment" "aks_monitoring" {
#   for_each             = var.aks_clusters
#   scope                = data.terraform_remote_state.loganalytics.outputs.law_id
#   role_definition_name = "Monitoring Metrics Publisher"
#   principal_id         = azurerm_kubernetes_cluster.this["aks1"].addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
# }

resource "azurerm_key_vault_access_policy" "aks_akv_access" {
  key_vault_id = data.terraform_remote_state.keyvault.outputs.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.this["aks1"].kubelet_identity[0].object_id

  key_permissions         = ["get"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
}
