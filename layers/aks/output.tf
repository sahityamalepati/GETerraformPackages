# #############################################################################
# # OUTPUTS Kubernetes
# #############################################################################

output "aks_resource_ids" {
  description = "List of Resource Id of AKS cluster's"
  value       = [for x in azurerm_kubernetes_cluster.this : x.id]
}

output "aks_resource_ids_map" {
  description = "Map of Resource Id of AKS cluster's"
  value       = { for x in azurerm_kubernetes_cluster.this : x.name => x.id }
}

output "aks" {
  value = azurerm_kubernetes_cluster.this
}
