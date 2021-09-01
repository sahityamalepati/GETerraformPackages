# #############################################################################
# # OUTPUTS APIM
# #############################################################################

output "api_id" {
  value = { for x in azurerm_api_management.att-apim : x.name => x.id }

}

output "apim" {
  value = azurerm_api_management.att-apim
}

