resource_group_name = "jstart-vmss-layered07142020"

dns_a_records = {
  arecord1 = {
    a_record_name         = "keyvault-arecord"                # <"dns+a_record_name">
    dns_zone_name         = "privatelink.vaultcore.azure.net" # <"dns_zone_name">
    ttl                   = 300                               # <time_to_live_of_the_dns_record_in_seconds>
    ip_addresses          = null                              # <list_of_ipv4_addresses>
    private_endpoint_name = "privateendpointkeyvault"         # <"name of private endpoint for which DNSARecord to be created"
  }
}

dns_cname_records = {
  cnamerecord1 = {
    cname_record_name = "keyvault-alias-record"
    dns_zone_name     = "privatelink.vaultcore.azure.net"
    ttl               = 300
    record            = "keyvault-arecord.privatelink.vaultcore.azure.net"
  }
}

dns_srv_records = {
  srvrecord1 = {
    srv_record_name = "_gc._tcp"
    dns_zone_name   = "abccorp.abc.com"
    ttl             = 600
    records = [
      {
        priority = 0
        weight   = 100
        port     = 3268
        target   = "ace2p08690dc001.itservices.abc.com"
      },
      {
        priority = 0
        weight   = 100
        port     = 3268
        target   = "ace2p08690dc002.itservices.abc.com"
      },
      {
        priority = 0
        weight   = 100
        port     = 3268
        target   = "ace2p08690dc003.itservices.abc.com"
      }
    ]
  }
}

dns_records_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}