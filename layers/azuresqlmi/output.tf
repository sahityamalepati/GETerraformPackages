output "sqlmi_properties" {
value = azurerm_template_deployment.sql_mi
}

output "identity" {
  value = { for v in azurerm_template_deployment.sql_mi : v.name => v.outputs["identity"] }
}