# #############################################################################
# # OUTPUTS Shared Image Gallery
# #############################################################################

output "sig_ids_map" {
  value = { for sig in azurerm_shared_image_gallery.this : sig.name => sig.id }
}

output "sig_ids" {
  value = [for sig in azurerm_shared_image_gallery.this : sig.id]
}

output "sig_names" {
  value = [for sig in azurerm_shared_image_gallery.this : sig.name]
}

output "sig_unique_names" {
  value = [for sig in azurerm_shared_image_gallery.this : sig.unique_name]
}

output "sig_unique_names_map" {
  value = { for sig in azurerm_shared_image_gallery.this : sig.name => sig.unique_name }
}
