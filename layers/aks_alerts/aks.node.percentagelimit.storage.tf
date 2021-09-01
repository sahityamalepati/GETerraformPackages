resource "azurerm_monitor_scheduled_query_rules_alert" "ansla" {
    for_each                = var.aks_node_storage_limit_alerts
    name                    = "Node Storage Usage Alert %{ if each.value["clusterName"] != "*" } for Cluster ${each.value["clusterName"]} %{ endif }"
    description             = "Alert for storage usage above the limit in a cluster."
    resource_group_name     = data.azurerm_resource_group.aks_alerts.name
    location                = data.azurerm_resource_group.aks_alerts.location
    data_source_id          = each.value["dataSourceId"]
    enabled                 = true

    frequency               = each.value["frequency"]
    time_window             = each.value["time_window"]

    throttling              = each.value["time_window"]
    severity                = each.value["severity"]

    action {
      action_group = [each.value["actionGroupId"]]
    }

    query                 = <<-QUERY
        let endDateTime = now();
        let startDateTime = ago(${each.value["time_window"]}m);
        let trendBinSize = ${each.value["frequency"]}m; %{ if each.value["clusterName"] != "*" }
        let clusterName = '${each.value["clusterName"]}'; %{ endif }
        KubePodInventory %{ if each.value["clusterName"] != "*" }
        | where ClusterName == clusterName %{ endif }
        | extend PodName = Name
        | distinct Computer
        | project Computer
        | join (
            InsightsMetrics
            | where TimeGenerated >= startDateTime
            | where TimeGenerated < endDateTime
            | where Origin == 'container.azm.ms/telegraf'
            | where Namespace == 'container.azm.ms/disk'
            | extend Tags = todynamic(Tags)
            | project TimeGenerated, ClusterId = tostring(Tags['container.azm.ms/clusterId']), Computer = tostring(Tags.hostName), Device = tostring(Tags.device), Path = tostring(Tags.path), DiskMetricName = Name,  DiskMetricValue = Val
        ) on Computer
        | where DiskMetricName == 'used_percent'
        | summarize AggregatedValue = avg(bin(todouble(DiskMetricValue), 0.01)) by bin(TimeGenerated, trendBinSize), Computer, Device, Path
    QUERY

    trigger {
        operator    = "GreaterThan"
        threshold   = each.value["storageThreshold"]
        metric_trigger {
          operator = "GreaterThan"
          threshold = each.value["countThreshold"] #3
          metric_trigger_type = "Consecutive"
          metric_column = "Computer,Device,Path"
      }
    }
}

output "aks_node_storage_limit_alerts_ids" {
    value = [for x in azurerm_monitor_scheduled_query_rules_alert.ansla : x.id]
}