# #############################################################################
# # OUTPUTS Azure SQL Server
# #############################################################################

output "azuresql_server_id" {
  value       = azurerm_mssql_server.this.id
  description = "The server id of Azure SQL Server"
}

output "azuresql_server_name" {
  value       = azurerm_mssql_server.this.name
  description = "The server name of Azure SQL Server"
}

output "azuresql_fqdn" {
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
  description = "The fully qualified domain name of the Azure SQL Server"
}

output "azuresql_version" {
  value       = azurerm_mssql_server.this.version
  description = "The version of the Azure SQL Server."
}

output "azuresql_databases_names" {
  value       = [for x in azurerm_mssql_database.this : x.name]
  description = "List of all Azure SQL database resource names"
}

output "azuresql_databases_ids" {
  value       = [for x in azurerm_mssql_database.this : x.id]
  description = "The list of all Azure SQL database resource ids"
}

output "azuresql_databases_ids_map" {
  value       = { for x in azurerm_mssql_database.this : x.name => x.id }
  description = "The map of all Azure SQL database resource ids"
}

output "azuresql_database_connection_strings" {
  value = {
    for x in azurerm_mssql_database.this :
    x.name => "Server=tcp:${azurerm_mssql_server.this.fully_qualified_domain_name},1433;Initial Catalog=${x.name};Persist Security Info=False;User ID=${azurerm_mssql_server.this.administrator_login};Password=${azurerm_mssql_server.this.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
  description = "Connection strings for the Azure SQL Databases created."
  sensitive   = true
}