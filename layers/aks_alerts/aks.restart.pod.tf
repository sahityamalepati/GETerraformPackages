resource "azurerm_monitor_scheduled_query_rules_alert" "apra" {
    for_each                = var.aks_pod_restart_alerts
    name                    = "Pod Restart Loop Detected %{ if each.value["clusterName"] != "*" } on Cluster ${each.value["clusterName"]} %{ endif }" 
    description             = "Alert for a pod restart loop is detected in a given cluster."
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
  | summarize AggregatedValue = sum(PodRestartCount) by bin(TimeGenerated, trendBinSize), Name, ClusterName
    QUERY

    trigger {
        operator    = "GreaterThan"
        threshold   = each.value["restartThreshold"]
        metric_trigger {
          operator = "GreaterThan"
          threshold = each.value["countThreshold"]
          metric_trigger_type = "Total"
          metric_column = "Name"
      }
    }
}

output "aks_pod_restart_alerts_ids" {
    value = [for x in azurerm_monitor_scheduled_query_rules_alert.apra : x.id]
}