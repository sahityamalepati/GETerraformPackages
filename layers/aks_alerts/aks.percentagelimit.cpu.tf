resource "azurerm_monitor_scheduled_query_rules_alert" "ancla" {
    for_each                = var.aks_node_cpu_limit_alerts
    name                    = "Node Avg CPU Threshold Exceeded %{ if each.value["clusterName"] != "*" } for Cluster ${each.value["clusterName"]} %{endif}"
    description             = "Alert for when the CPU theshold for Nodes associated with the cluster goes above the defined limit."
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
    let trendBinSize = ${each.value["frequency"]}m;
    let capacityCounterName = 'cpuCapacityNanoCores';
    let usageCounterName = 'cpuUsageNanoCores'; %{ if each.value["clusterName"] != "*"}
    let clusterName = '${each.value["clusterName"]}'; %{endif}
    KubeNodeInventory
    | where TimeGenerated < endDateTime
    | where TimeGenerated >= startDateTime %{ if each.value["clusterName"] != "*"}
    | where ClusterName == clusterName %{endif}
    | distinct ClusterName, Computer
    | join
        hint.strategy=shuffle ( Perf
        | where TimeGenerated < endDateTime
        | where TimeGenerated >= startDateTime
        | where ObjectName == 'K8SNode'
        | where CounterName == capacityCounterName
        | summarize LimitValue = max(CounterValue) by Computer, CounterName, bin(TimeGenerated, trendBinSize)
        | project Computer, CapacityStartTime = TimeGenerated, CapacityEndTime = TimeGenerated + trendBinSize, LimitValue
    )
    on Computer
    | join kind=inner
        hint.strategy=shuffle ( Perf
        | where TimeGenerated < endDateTime + trendBinSize
        | where TimeGenerated >= startDateTime - trendBinSize
        | where ObjectName == 'K8SNode'
        | where CounterName == usageCounterName
        | project Computer, UsageValue = CounterValue, TimeGenerated
    )
    on Computer
    | where TimeGenerated >= CapacityStartTime and TimeGenerated < CapacityEndTime
    | project ClusterName, Computer, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue
    | summarize AggregatedValue = avg(UsagePercent) by bin(TimeGenerated, trendBinSize), ClusterName, Computer
    QUERY

    trigger {
        operator    = "GreaterThan"
        threshold   = each.value["cpuThreshold"]
        metric_trigger {
            operator = "GreaterThan"
            threshold = each.value["countThreshold"]
            metric_trigger_type = "Total"
            metric_column = "Computer"
      }
    }
}

output "aks_node_cpu_limit_alerts_ids" {
    value = [for x in azurerm_monitor_scheduled_query_rules_alert.ancla : x.id]
}