resource_group_name = "jstart-all-dev-02012022"

dns_a_records = {
  arecord1 = {
    a_record_name         = "jstartall02012022kv"             # <"dns+a_record_name">
    dns_zone_name         = "privatelink.vaultcore.azure.net" # <"dns_zone_name">
    ttl                   = 300                               # <time_to_live_of_the_dns_record_in_seconds>
    ip_addresses          = null                              # <list_of_ipv4_addresses>
    private_endpoint_name = "privateendpointkeyvault"         # <"name of private endpoint for which DNSARecord to be created"
  },
  arecord2 = {
    a_record_name         = "functionapp02012022"           # <"dns+a_record_name">
    dns_zone_name         = "privatelink.azurewebsites.net" # <"dns_zone_name">
    ttl                   = 300                             # <time_to_live_of_the_dns_record_in_seconds>
    ip_addresses          = null                            # <list_of_ipv4_addresses>
    private_endpoint_name = "privateendpointazfunc"         # <"name of private endpoint for which DNSARecord to be created"
  }
}

dns_records_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}