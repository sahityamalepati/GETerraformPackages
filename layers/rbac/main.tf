resource "azurerm_role_definition" "this" {
  for_each    =  var.role_definitions
  name        = each.value["name"]
  description = each.value["description"]
  scope       =  each.value["scope"]  

  permissions {
    actions     = each.value["actions"]
    not_actions = each.value["not_actions"]
  }

  assignable_scopes = each.value["assignable_scopes"]
}

resource "azurerm_role_assignment" "this" {
  for_each             = var.role_assignments 
  scope                = each.value["scope"]
  role_definition_name = each.value["role_definition_name"]
  principal_id         = each.value["principal_id"] 
  depends_on           = [azurerm_role_definition.this]
}
