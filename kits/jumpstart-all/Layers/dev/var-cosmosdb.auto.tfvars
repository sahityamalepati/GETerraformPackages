resource_group_name = "jstart-all-dev-02012022"

allowed_networks = [{
  subnet_name               = "loadbalancer"
  vnet_name                 = null #"jstartvmssfirst"
  networking_resource_group = "jstart-all-dev-02012022"
}]

cosmosdb_account = {
  database_name                     = "jstartall02012022cosmos"
  offer_type                        = "Standard"
  kind                              = "MongoDB"
  enable_multiple_write_locations   = false
  enable_automatic_failover         = true
  is_virtual_network_filter_enabled = true
  ip_range_filter                   = null
  api_type                          = "EnableMongo"
  consistency_level                 = "BoundedStaleness"
  max_interval_in_seconds           = 300
  max_staleness_prefix              = 100000
  failover_location                 = "eastus"
}

throughput          = 400
default_ttl_seconds = 0

cosmosdb_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
  pe_enable    = true
}
