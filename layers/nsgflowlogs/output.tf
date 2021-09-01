output "network_watcher_name" {
  value = [for x in azurerm_network_watcher_flow_log.this : x.network_watcher_name]
}