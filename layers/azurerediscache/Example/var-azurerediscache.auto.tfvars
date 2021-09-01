resource_group_name = "[__resoure_group_name__]"

redis_cache_instances = {
  rc1 = {
    name                      = "jstartall11222020rediscache"
    capacity                  = 1
    sku                       = "Premium"
    enable_non_ssl_port       = false
    minimum_tls_version       = "1.2"
    subnet_name               = "loadbalancer"
    vnet_name                 = null #"jstartvmssfirst"
    networking_resource_group = "[__networking_resoure_group_name__]"
    static_ip                 = null
    shard_count               = 1
    patch_schedules           = null
    redis_configuration = {
      enable_authentication           = true
      maxmemory_reserved              = null
      maxmemory_delta                 = null
      maxmemory_policy                = null
      maxfragmentationmemory_reserved = null
      rdb_backup_enabled              = true
      rdb_backup_frequency            = 60
      rdb_backup_max_snapshot_count   = null
      backup_storage_account_name     = "jstartall11222020sa"
    }
  }
}

firewall_rules = [{
  name             = "defaultfratt11222020"
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
  redis_cache_key  = "rc1"
}]

redis_cache_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}