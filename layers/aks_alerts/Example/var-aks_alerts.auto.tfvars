subscriptionId = "subscription_id"
tenantId = "tenant_id"

resource_group_name = "resource_group_name"

aks_pod_not_ready_alerts = {
    apnra1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        pendingThreshold    = 1
        countThreshold      = 3
    }
}

aks_node_storage_limit_alerts = {
    ansla1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        storageThreshold    = 90
        countThreshold      = 3
    }
}

aks_node_memory_limit_alerts = {
    anmla1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        memThreshold        = 90
        countThreshold      = 3
    }
}

aks_node_cpu_limit_alerts = {
    ancla1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        cpuThreshold        = 90
        countThreshold      = 3
    }
}

aks_pod_mem_limit_alerts = {
    apmla1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        memThreshold        = 90
        countThreshold      = 3
    }
}

aks_pod_cpu_limit_alerts = {
    apcla1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        cpuThreshold        = 90
        countThreshold      = 3
    }
}

aks_pod_restart_alerts = {
    apra1 = {
        clusterName         = "*"
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        frequency           = 5
        time_window         = 30
        severity            = 3
        restartThreshold    = 1
        countThreshold      = 3
    }
}