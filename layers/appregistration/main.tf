# Create an application
resource "azuread_application" "this" {
  for_each                    = var.application_names
  name                         = each.value.name
  homepage                   = "https://${each.value.name}"
  identifier_uris            = ["https://${each.value.name}"]
  reply_urls                 = ["https://${each.value.name}.azurewebsites.net/.auth/login/aad/callback"]
  available_to_other_tenants = each.value.available_to_other_tenants
  oauth2_allow_implicit_flow = each.value.oauth2_allow_implicit_flow
}