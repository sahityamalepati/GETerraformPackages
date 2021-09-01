resource "azurerm_shared_image_gallery" "sig" {
  for_each            = var.shared_image_gallery
  name                = replace("${var.common_vars.name_prefix}${each.value["name"]}", "-", "")
  resource_group_name = var.rg_name
  location            = each.value["region"]
  description         = "The SIG is used to build application images for application teams"
  tags                = var.common_vars.tags
}

output image_name {
  value = [for i in azurerm_shared_image_gallery.sig : i.name]
}