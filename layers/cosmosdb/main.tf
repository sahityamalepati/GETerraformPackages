data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? { for x in var.allowed_networks : x.subnet_name => x } : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

locals {
  tags                       = merge(var.cosmosdb_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
}

# -
# - Azure CosmosDB Account
# -
resource "azurerm_cosmosdb_account" "this" {
  name                = lookup(var.cosmosdb_account, "database_name")
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  offer_type          = coalesce(lookup(var.cosmosdb_account, "offer_type"), "Standard")
  kind                = coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB")

  enable_multiple_write_locations = coalesce(lookup(var.cosmosdb_account, "enable_multiple_write_locations"), false)
  enable_automatic_failover       = coalesce(lookup(var.cosmosdb_account, "enable_automatic_failover"), true)

  is_virtual_network_filter_enabled = coalesce(lookup(var.cosmosdb_account, "is_virtual_network_filter_enabled"), true)
  ip_range_filter                   = lookup(var.cosmosdb_account, "ip_range_filter")

  dynamic "virtual_network_rule" {
    for_each = coalesce(var.allowed_networks, [])
    content {
      id = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, virtual_network_rule.value.subnet_name, null) : lookup(data.azurerm_subnet.this, virtual_network_rule.value.subnet_name)["id"]
    }
  }

  dynamic "capabilities" {
    for_each = coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") != null ? [coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4")] : []
    content {
      name = capabilities.value
    }
  }

  consistency_policy {
    consistency_level       = coalesce(lookup(var.cosmosdb_account, "consistency_level"), "BoundedStaleness")
    max_interval_in_seconds = coalesce(lookup(var.cosmosdb_account, "consistency_level"), "BoundedStaleness") == "BoundedStaleness" ? coalesce(lookup(var.cosmosdb_account, "max_interval_in_seconds"), 300) : null
    max_staleness_prefix    = coalesce(lookup(var.cosmosdb_account, "consistency_level"), "BoundedStaleness") == "BoundedStaleness" ? coalesce(lookup(var.cosmosdb_account, "max_staleness_prefix"), 100000) : null
  }

  geo_location {
    location          = lookup(var.cosmosdb_account, "failover_location")
    failover_priority = 1
  }

  geo_location {
    prefix            = "${lookup(var.cosmosdb_account, "database_name")}-main"
    location          = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
    failover_priority = 0
  }

  tags = local.tags
}

locals {
  provisionMongoDB           = (coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "MongoDBv3.4" || coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "EnableMongo") && coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB") == "MongoDB"
  provisionCassandraKeyspace = coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "EnableCassandra" && coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB") == "GlobalDocumentDB"
  provisionTable             = coalesce(lookup(var.cosmosdb_account, "api_type"), "MongoDBv3.4") == "EnableTable" && coalesce(lookup(var.cosmosdb_account, "kind"), "MongoDB") == "GlobalDocumentDB"
}

# -
# - Create Mongo DB
# -
resource "azurerm_cosmosdb_mongo_database" "this" {
  count               = local.provisionMongoDB ? 1 : 0
  name                = "cosmos-mongo-db"
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this]
}

# -
# - Create Mongo Collection
# -
resource "azurerm_cosmosdb_mongo_collection" "this" {
  count               = local.provisionMongoDB ? 1 : 0
  name                = "cosmos-mongo-collection"
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = element(azurerm_cosmosdb_mongo_database.this.*.name, 0)

  default_ttl_seconds = var.default_ttl_seconds
  shard_key           = var.shard_key
  throughput          = var.throughput

  dynamic "index" {
    for_each = coalesce(var.indexes, [{ keys = ["_id"], unique = false }])
    content {
      keys   = index.value.keys
      unique = coalesce(index.value.unique, false)
    }
  }

  depends_on = [azurerm_cosmosdb_account.this, azurerm_cosmosdb_mongo_database.this]
}

# -
# - Creates Cosmos DB Cassendra Keyspace
# -
resource "azurerm_cosmosdb_cassandra_keyspace" "this" {
  count               = local.provisionCassandraKeyspace ? 1 : 0
  name                = "cosmos-cassandra-keyspace"
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this]
}

# -
# - Creates Cosmos DB Table
# -
resource "azurerm_cosmosdb_table" "this" {
  count               = local.provisionTable ? 1 : 0
  name                = "cosmos-table"
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput
  depends_on          = [azurerm_cosmosdb_account.this]
}
