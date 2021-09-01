resource_group_name = "jstart-all-dev-10022020"

traffic_manager_profiles = {
  tmp1 = {
    name                         = "trfmanagerprofile10022020"
    routing_method               = "Performance"
    profile_status               = null
    relative_domain_name         = null
    ttl                          = 100
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
    expected_status_code_ranges  = null
    custom_headers               = null
  }
}

traffic_manager_endpoints = {
  tme1 = {
    name                          = "functionappendpoint"
    profile_key                   = "tmp1"
    profile_status                = null
    type                          = "azureEndpoints"
    target                        = null
    target_resource_endpoint_name = "functionapp10022020"
    weight                        = null
    priority                      = null
    endpoint_location             = null
    custom_headers                = null
  },
  tme2 = {
    name                          = "appgwpipendpoint"
    profile_key                   = "tmp1"
    profile_status                = null
    type                          = "azureEndpoints"
    target                        = null
    target_resource_endpoint_name = "appgateway-feip"
    weight                        = null
    priority                      = null
    endpoint_location             = null
    custom_headers                = null
  }
}

# resource_ids = {
#   "functionapp10022020" = "/subscriptions/9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51/resourceGroups/jstart-all-dev-10022020/providers/Microsoft.Web/sites/functionapp10022020"
# }

traffic_manager_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}