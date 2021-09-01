resource "azurerm_monitor_metric_alert" "vmplcpu" {
  for_each            = var.vm_percentagelimit_cpu_alert
  name                = "Processor Utilization Time"

  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = [each.value["scope"]]
  description         = "Processor Utilization Time"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Processor Time"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = each.value["threshold"]

    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = each.value["actionGroupId"]
  }
}

output "vm_percentagelimit_cpu_alert_ids" {
    value = [for x in azurerm_monitor_metric_alert.vmplcpu : x.id]
}