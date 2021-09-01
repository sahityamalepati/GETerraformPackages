output "postgresql_names" {
  value = [for k in azurerm_postgresql_server.this : k.name]
}

output "postgresql_id" {
  value = [for k in azurerm_postgresql_server.this : k.id]
}

output "postgresql_ids_map" {
  value = { for x in azurerm_postgresql_server.this : x.name => x.id }
}
