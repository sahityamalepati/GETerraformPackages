resource "azurerm_monitor_metric_alert" "vmwpfds" {
  for_each            = var.vm_windows_percentagefree_disk_alert
  name                = "Windows-Percent Used Space"

  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = [each.value["scope"]]
  description         = "Windows-Percent Used Space"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Free Space"
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

output "vm_windows_percentagefree_disk_alert_ids" {
    value = [for x in azurerm_monitor_metric_alert.vmwpfds : x.id]
}