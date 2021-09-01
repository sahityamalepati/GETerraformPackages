output "application_id_map" {
    value       = { for x in azuread_application.this : x.name => x.application_id }
}