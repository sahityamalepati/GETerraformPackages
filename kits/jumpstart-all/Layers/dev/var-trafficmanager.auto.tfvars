resource_group_name = "jstart-all-dev-02012022"

traffic_manager_profiles = {
  tmp1 = {
    name                         = "trfmanagerprofile02012022"
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
    target_resource_endpoint_name = "functionapp02012022"
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
#   "functionapp02012022" = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/Microsoft.Web/sites/functionapp02012022"
# }

traffic_manager_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}