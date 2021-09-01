# -
# - Create Resource Groups and assign mandatory tags
# -
resource "azurerm_resource_group" "this" {
  for_each = var.resource_groups
  name     = each.value["name"]
  location = each.value["location"]
  tags     = each.value["tags"]
}
