resource "azurerm_monitor_scheduled_query_rules_alert" "apmla" {
    for_each                = var.aks_pod_mem_limit_alerts
    name                    = "Pod Avg Memory Alert %{ if each.value["clusterName"] != "*" } for Cluster ${each.value["clusterName"]} %{ endif }" 
    description             = "Alert for a pod Memory Usage above the percentage limit in a given cluster."
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
    let capacityCounterName = 'memoryLimitBytes';
    let usageCounterName = 'memoryRssBytes'; %{ if each.value["clusterName"] != "*" }
    let clusterName = '${each.value["clusterName"]}'; %{ endif }
    KubePodInventory
    | where TimeGenerated < endDateTime
    | where TimeGenerated >= startDateTime %{ if each.value["clusterName"] != "*" }
    | where ClusterName == clusterName %{ endif }
    | extend InstanceName = strcat(ClusterId, '/', ContainerName),
        ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),
        PodName = Name
    | project Computer, InstanceName, ContainerName, ClusterName, Namespace, PodName
    | join hint.strategy=shuffle (
        Perf
        | where TimeGenerated < endDateTime
        | where TimeGenerated >= startDateTime
        | where ObjectName == 'K8SContainer'
        | where CounterName == capacityCounterName
        | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)
        | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue
    ) on Computer, InstanceName
    | join kind=inner hint.strategy=shuffle (
        Perf
        | where TimeGenerated < endDateTime + trendBinSize
        | where TimeGenerated >= startDateTime - trendBinSize
        | where ObjectName == 'K8SContainer'
        | where CounterName == usageCounterName
        | project Computer, InstanceName, UsageValue = CounterValue, TimeGenerated
    ) on Computer, InstanceName
    | where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime
    | project Computer, ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue, ClusterName, Namespace, PodName
    | summarize AggregatedValue = avg(UsagePercent) by bin(TimeGenerated, trendBinSize) , ContainerName, ClusterName, Namespace, PodName
    QUERY

    trigger {
        operator    = "GreaterThan"
        threshold   = each.value["memThreshold"]
        metric_trigger {
          operator = "GreaterThan"
          threshold = each.value["countThreshold"]
          metric_trigger_type = "Total"
          metric_column = "PodName"
      }
    }
}

output "aks_pod_mem_limit_alerts_ids" {
    value = [for x in azurerm_monitor_scheduled_query_rules_alert.apmla : x.id]
}