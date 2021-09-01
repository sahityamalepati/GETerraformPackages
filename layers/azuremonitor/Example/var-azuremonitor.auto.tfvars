resource_group_name = "jstart-vmss-layered07142020"

action_groups = {
  ag1 = {
    name                     = "ag07142020"
    short_name               = "agshort"
    enabled                  = null
    arm_role_receivers       = null
    azure_app_push_receivers = null
    azure_function_receivers = null
    email_receivers          = null
    logic_app_receivers      = null
    voice_receivers          = null
    webhook_receivers        = null
    sms_receivers            = null
  }
}

metric_alerts = {
  ma1 = {
    name               = "metricalert07142020"
    resource_names     = ["vm-001"]
    enabled            = null
    description        = "Action will be triggered when Average Percentage CPU is greater than 70."
    auto_mitigate      = null
    frequency          = null
    severity           = null
    window_size        = null
    target_resource_location = null
    target_resource_type = null
    action_group_names = ["ag07142020"]
    criterias = [{
      metric_namespace = "Microsoft.Compute/virtualMachines"
      metric_name      = "Percentage CPU"
      aggregation      = "Average"
      operator         = "GreaterThan"
      threshold        = 50
      dimensions       = null
    }]
  }
}

activity_log_alerts = {
  ala1 = {
    name                = "activitylogalert10212020"
    description         = "Action will be triggered when Service Health Alert is generated for virtual machine"
    enabled             = null
    resource_names      = [var.subscription_id]
    action_group_names  = ["ag07142020"]
    criterias = [{
      category                = "ServiceHealth"
      operation_name          = null
      resource_provider       = null
      resource_type           = "Microsoft.Compute/virtualMachines"
      resource_group          = null
      resource_id             = null
      caller                  = null
      level                   = null
      status                  = null
      sub_status              = null
      recommendation_type     = null
      recommendation_category = null
      recommendation_impact   = null
  }
}

log_profiles = {
  lp1 = {
    name                             = "default"
    locations                        = ["westus", "global"]
    retention_days                   = 7
    diagnostics_storage_account_name = "jstartlayer08202020sa"
  }
}

query_rules_alerts = {
  qra1 = {
    name               = "cpu-utilization-alert"
    law_name           = "jstartlayer07142020law"
    frequency          = 5
    time_window        = 30
    action_group_names = ["ag07142020"]
    email_subject      = null
    description        = "CPU Utilization"
    enabled            = true
    severity           = 1
    throttling         = 5
    query              = <<-EOT
        InsightsMetrics
            | where Origin == "vm.azm.ms" 
            | where Namespace == "Processor" and Name == "UtilizationPercentage" 
            | summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId
      EOT
    trigger = {
      operator  = "GreaterThan"
      threshold = 3
      metric_trigger = {
        operator            = "GreaterThan"
        threshold           = 1
        metric_trigger_type = "Total"
        metric_column       = "operation_Name"
      }
    }
  }
}

azure_monitor_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
