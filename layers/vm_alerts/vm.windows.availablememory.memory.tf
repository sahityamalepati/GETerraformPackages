resource "azurerm_monitor_metric_alert" "vmwam" {
  for_each            = var.vm_windows_availablememory_alert
  name                = "Windows-Available Megabytes"

  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = [each.value["scope"]]
  description         = "Windows-Available Megabytes"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_Available MBytes"
    aggregation      = "Average"
    operator         = "LessThan"
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

output "vm_windows_availablememory_alert_ids" {
    value = [for x in azurerm_monitor_metric_alert.vmwam : x.id]
}