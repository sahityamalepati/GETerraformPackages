# #############################################################################
# # OUTPUTS DNS Records
# #############################################################################

output "dns_a_record_fqdn_map" {
  value       = { for a in azurerm_private_dns_a_record.this : a.name => a.fqdn... }
  description = "A Map of FQDN of the DNS A Records"
}

output "dns_a_record_ids_map" {
  value       = { for a in azurerm_private_dns_a_record.this : a.name => a.id... }
  description = "A Map of Id of the DNS A Records"
}

output "dns_cname_record_fqdn_map" {
  value       = { for cname in azurerm_private_dns_cname_record.this : cname.name => cname.fqdn... }
  description = "A Map of FQDN of the DNS CNAME Records"
}

output "dns_cname_record_ids_map" {
  value       = { for cname in azurerm_private_dns_cname_record.this : cname.name => cname.id... }
  description = "A Map of Id of the DNS CNAME Records"
}

output "dns_srv_record_fqdn_map" {
  value       = { for srv in azurerm_private_dns_srv_record.this : srv.name => srv.fqdn... }
  description = "A Map of FQDN of the DNS SRV Records"
}

output "dns_srv_record_ids_map" {
  value       = { for srv in azurerm_private_dns_srv_record.this : srv.name => srv.id... }
  description = "A Map of Id of the DNS SRV Records"
}
