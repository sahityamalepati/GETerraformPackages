variable "aks_pod_restart_alerts" {
  type = map(object({
    clusterName         = string
    dataSourceId        = string
    actionGroupId       = string
    frequency           = number
    time_window         = number
    severity            = number
    restartThreshold    = number
    countThreshold      = number
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
     apra1 = {
        clusterName         = "cluster_name"
        dataSourceId        = "full_dataSource_id"
        actionGroupId       = "full_actionGroup_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        restartThreshold    = 1
        countThreshold      = 3
    }
  }
}