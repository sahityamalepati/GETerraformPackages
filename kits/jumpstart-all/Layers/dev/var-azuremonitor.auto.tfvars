resource_group_name = "jstart-all-dev-02012022"

action_groups = {
  ag1 = {
    name                     = "ag02012022"
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
    name                     = "metricalertvm"
    resource_names           = ["jstartvm001"]
    enabled                  = null
    description              = "Action will be triggered when Average Percentage CPU is greater than 70."
    auto_mitigate            = null
    frequency                = null
    severity                 = null
    window_size              = null
    action_group_names       = ["ag02012022"]
    target_resource_type     = null
    target_resource_location = null
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

query_rules_alerts = {
  qra1 = {
    name               = "cpu-utilization-alert"
    law_name           = "jstartall02012022law"
    frequency          = 5
    time_window        = 30
    action_group_names = ["ag02012022"]
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
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}