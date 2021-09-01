data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

locals {
  tags                       = merge((local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags), var.traffic_manager_additional_tags)
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
}

resource "random_id" "this" {
  keepers = {
    azi_id = 1
  }
  byte_length = 8
}

# -
# - Traffic Manager Profile
# -
resource "azurerm_traffic_manager_profile" "this" {
  for_each               = var.traffic_manager_profiles
  name                   = each.value["name"]
  resource_group_name    = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  traffic_routing_method = each.value["routing_method"]
  profile_status         = lookup(each.value, "profile_status", "Enabled")

  dns_config {
    relative_name = lookup(each.value, "relative_domain_name", null) == null ? random_id.this.hex : each.value["relative_domain_name"]
    ttl           = each.value["ttl"]
  }

  monitor_config {
    protocol                     = each.value["protocol"]
    port                         = each.value["port"]
    path                         = (each.value["protocol"] == "HTTP" || each.value["protocol"] == "HTTPS") ? each.value["path"] : lookup(each.value, "path", null)
    interval_in_seconds          = lookup(each.value, "interval_in_seconds", null)
    timeout_in_seconds           = lookup(each.value, "timeout_in_seconds", null)
    tolerated_number_of_failures = lookup(each.value, "tolerated_number_of_failures", null)
    expected_status_code_ranges  = lookup(each.value, "expected_status_code_ranges", null)

    dynamic "custom_header" {
      for_each = (each.value["protocol"] == "HTTP" || each.value["protocol"] == "HTTPS") ? coalesce(lookup(each.value, "custom_headers"), []) : []
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
  }

  tags = local.tags
}

# -
# - Traffic Manager Endpoint
# -
resource "azurerm_traffic_manager_endpoint" "this" {
  for_each            = var.traffic_manager_endpoints
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  profile_name        = azurerm_traffic_manager_profile.this[each.value["profile_key"]].name
  endpoint_status     = lookup(each.value, "profile_status", "Enabled")

  type               = each.value["type"]
  target             = each.value["type"] == "externalEndpoints" ? lookup(each.value, "target", null) : null
  target_resource_id = ((each.value["type"] == "azureEndpoints" || each.value["type"] == "nestedEndpoints") && each.value.target_resource_endpoint_name != null) ? lookup(var.resource_ids, each.value.target_resource_endpoint_name, null) : null
  weight             = azurerm_traffic_manager_profile.this[each.value["profile_key"]].traffic_routing_method == "Weighted" ? lookup(each.value, "weight", null) : null
  priority           = azurerm_traffic_manager_profile.this[each.value["profile_key"]].traffic_routing_method == "Priority" ? lookup(each.value, "priority ", null) : null
  endpoint_location  = (azurerm_traffic_manager_profile.this[each.value["profile_key"]].traffic_routing_method == "Performance" && (each.value["type"] == "externalEndpoints" || each.value["type"] == "nestedEndpoints")) ? lookup(each.value, "endpoint_location", null) : null

  dynamic "custom_header" {
    for_each = (azurerm_traffic_manager_profile.this[each.value["profile_key"]].monitor_config[0].protocol == "HTTP" || azurerm_traffic_manager_profile.this[each.value["profile_key"]].monitor_config[0].protocol == "HTTPS") ? coalesce(lookup(each.value, "custom_headers"), []) : []
    content {
      name  = custom_header.value.name
      value = custom_header.value.value
    }
  }

  depends_on = [azurerm_traffic_manager_profile.this]
}
