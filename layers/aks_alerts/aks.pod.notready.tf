resource "azurerm_monitor_scheduled_query_rules_alert" "apnra" {
    for_each                = var.aks_pod_not_ready_alerts
    name                    = "Pod Not Ready Alert %{ if each.value["clusterName"] != "*" } for ${each.value["clusterName"]} %{ endif }" 
    description             = "Alert for when pods are not in ready status."
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
    KubePodInventory
    | where TimeGenerated < endDateTime
    | where TimeGenerated >= startDateTime %{ if each.value["clusterName"] != "*" }
    | where ClusterName == clusterName %{ endif }
    | distinct Name, ClusterName, TimeGenerated
    | summarize ClusterSnapshotCount = count() by bin(TimeGenerated, trendBinSize), Name, ClusterName
    | join hint.strategy=broadcast (
        KubePodInventory
        | where TimeGenerated < endDateTime
        | where TimeGenerated >= startDateTime
        | distinct Name, Computer, PodUid, TimeGenerated, PodStatus
        | summarize TotalCount = count(),
                    PendingCount = sumif(1, PodStatus =~ 'Pending'),
                    RunningCount = sumif(1, PodStatus =~ 'Running'),
                    SucceededCount = sumif(1, PodStatus =~ 'Succeeded'),
                    FailedCount = sumif(1, PodStatus =~ 'Failed')
                 by Name, bin(TimeGenerated, trendBinSize)
    ) on Name, TimeGenerated
    | extend UnknownCount = TotalCount - PendingCount - RunningCount - SucceededCount - FailedCount
    | project TimeGenerated,
                Name,
                ClusterName,
              TotalCount = todouble(TotalCount) / ClusterSnapshotCount,
              PendingCount = todouble(PendingCount) / ClusterSnapshotCount,
              RunningCount = todouble(RunningCount) / ClusterSnapshotCount,
              SucceededCount = todouble(SucceededCount) / ClusterSnapshotCount,
              FailedCount = todouble(FailedCount) / ClusterSnapshotCount,
              UnknownCount = todouble(UnknownCount) / ClusterSnapshotCount
    | summarize AggregatedValue = avg(PendingCount) by bin(TimeGenerated, trendBinSize), Name, ClusterName
    QUERY

    trigger {
        operator    = "GreaterThan"
        threshold   = each.value["pendingThreshold"]
        metric_trigger {
          operator = "GreaterThan"
          threshold = each.value["countThreshold"] #3
          metric_trigger_type = "Total"
          metric_column = "Name"
      }
    }
}

output "aks_pod_not_ready_alerts_ids" {
    value = [for x in azurerm_monitor_scheduled_query_rules_alert.apnra : x.id]
}
