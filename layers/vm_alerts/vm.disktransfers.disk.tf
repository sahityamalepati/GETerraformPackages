resource "azurerm_monitor_metric_alert" "vmdisktransfersdisk" {
  for_each            = var.vm_disktransfers_disk_alert
  name                = "Average Disk Transfers per Second"

  resource_group_name = data.azurerm_resource_group.this.name
  scopes              = [each.value["scope"]]
  description         = "Average Disk Transfers per Second"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_Disk Transfers/sec"
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

output "vm_disktransfers_disk_alert_ids" {
    value = [for x in azurerm_monitor_metric_alert.vmdisktransfersdisk : x.id]
}