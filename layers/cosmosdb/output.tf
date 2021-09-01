# #############################################################################
# # OUTPUTS Cosmos DB
# #############################################################################

output "cosmosdb_id" {
  description = "CosmosDB Account Id"
  value       = azurerm_cosmosdb_account.this.id
}

output "cosmosdb_endpoint" {
  description = "The endpoint used to connect to the CosmosDB Account"
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_master_key" {
  description = "The Primary master key for the CosmosDB Account"
  value       = azurerm_cosmosdb_account.this.primary_master_key
}

output "secondary_master_key" {
  description = "The Secondary master key for the CosmosDB Account"
  value       = azurerm_cosmosdb_account.this.secondary_master_key
}

output "cassandra_api_id" {
  description = "The Cosmos DB Cassandra KeySpace Id"
  value       = azurerm_cosmosdb_cassandra_keyspace.this.*.id
}

output "table_api_id" {
  description = "The Cosmos DB Table Id"
  value       = azurerm_cosmosdb_table.this.*.id
}

output "mongo_api_id" {
  description = "The Cosmos DB Mongo Database Id"
  value       = azurerm_cosmosdb_mongo_database.this.*.id
}
