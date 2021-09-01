resource "azurerm_monitor_metric_alert" "vmlinuxpercentusedspacedisk" {
  for_each            = var.vm_linux_percentused_disk_alert
  name                = "Linux-Percent Used Space"

  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = [each.value["scope"]]
  description         = "Linux-Percent Used Space"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Used Space"
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

output "vm_linux_percentused_disk_alert_ids" {
    value = [for x in azurerm_monitor_metric_alert.vmlinuxpercentusedspacedisk : x.id]
}