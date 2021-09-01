resource_group_name = "[__resoure_group_name__]"

private_dns_zones = {
  zone1 = {
    dns_zone_name = "privatelink.vaultcore.azure.net"
    zone_exists   = false
    vnet_links = [
      {
        zone_to_vnet_link_name    = "first-vnet-link"
        vnet_name                 = "jstartvmssfirst"
        networking_resource_group = "[__networking_resoure_group_name__]"
        zone_to_vnet_link_exists  = false
      }
    ]
    registration_enabled = false
  },
  zone2 = {
    dns_zone_name = "privatelink.azurewebsites.net"
    zone_exists   = false
    vnet_links = [
      {
        zone_to_vnet_link_name    = "first-vnet-link"
        vnet_name                 = "jstartvmssfirst"
        networking_resource_group = "[__networking_resoure_group_name__]"
        zone_to_vnet_link_exists  = false
      }
    ]
    registration_enabled = false
  }
}

dns_zone_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}