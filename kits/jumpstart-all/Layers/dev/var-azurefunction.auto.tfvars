resource_group_name = "jstart-all-dev-02012022"

function_apps = {
  fa1 = {
    name                 = "functionapp02012022"
    app_service_plan_key = "asp1"
    app_settings = {
      "FUNCTIONS_WORKER_RUNTIME"         = "powershell"
      "FUNCTIONS_EXTENSION_VERSION"      = "~3"
      "FUNCTIONS_WORKER_RUNTIME_VERSION" = "~7"
    }
    storage_account_name    = "jstartall02012022sa"
    os_type                 = null
    client_affinity_enabled = null
    enabled                 = null
    https_only              = null
    assign_identity         = true
    auth_settings           = null
    connection_strings      = null
    version                 = "~3"
    site_config             = null
    enable_monitoring       = true
  }
}

app_service_plans = {
  asp1 = {
    name                         = "jstart-functionapp"
    kind                         = "FunctionApp"
    reserved                     = false
    per_site_scaling             = null
    maximum_elastic_worker_count = 20
    sku_tier                     = "ElasticPremium"
    sku_size                     = "EP1"
    sku_capacity                 = 3
  }
}

application_insights_name = "appinsights02012022"

vnet_swift_connection = {
  vsc1 = {
    function_app_key          = "fa1"
    subnet_name               = "azfunction"
    vnet_name                 = null #"jstartvmfirst"
    networking_resource_group = "jstart-all-dev-02012022"
  }
}

function_app_additional_tags = {
  iac                   = "Terraform"
  env                   = "uat"
  automated_by          = ""
  trafficmanager_enable = true
  pe_enable             = true
}