locals {
  mandatory_tags = {
    env = lower(terraform.workspace)
    # TODO: add more
  }

  tags = merge(local.mandatory_tags, var.common_vars.tags)
}

resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = "${var.common_vars.name_prefix}-${each.value["name"]}-rg"
  location = var.common_vars.region
  tags     = var.common_vars.tags
}
