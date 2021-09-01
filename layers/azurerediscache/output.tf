# #############################################################################
# # OUTPUTS Azure Redi Cache
# #############################################################################

output "redis_cache_ids_map" {
  value = { for r in azurerm_redis_cache.this : r.name => r.id }
}

output "redis_cache_hostnames_map" {
  value = { for r in azurerm_redis_cache.this : r.name => r.hostname }
}

output "redis_cache_connection_strings_map" {
  value = { for r in azurerm_redis_cache.this : r.name => r.primary_connection_string }
}
