resource "azurerm_monitor_scheduled_query_rules_alert" "vmrwbsa" {
    for_each            = var.vm_readwritebytespersec_network_alert
    name                    = "Network - Read-Write Bytes per Second"
    description             = "Alert when Read-Write Bytes per Second > 1024"
    resource_group_name     = data.azurerm_resource_group.this.name
    location                = data.azurerm_resource_group.this.location
    data_source_id          = each.value["dataSourceId"]
    frequency               = 5
    time_window             = 10
    enabled                 = true
    
  

 query                 = <<-QUERY
  InsightsMetrics
| where Namespace contains "Network"
| where Name == "ReadBytesPerSecond" or Name == "WriteBytesPerSecond"
| where Val > 512000

    QUERY
    

    trigger {
        operator    = "GreaterThan"
        threshold   = 1
    }
  
  action {
      action_group = [each.value["actionGroupId"]]
    }
}

output "vm_readwritebytespersec_network_alert_ids" {
    value = [for x in azurerm_monitor_scheduled_query_rules_alert.vmrwbsa : x.id]
}