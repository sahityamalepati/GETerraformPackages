resource_group_name = "jstart-all-dev-02012022"

flow_logs = {
  flowlog1 = {
    nsg_name                 = "nsg1"
    storage_account_name     = "jstartall02012022sa"
    network_watcher_name     = "NetworkWatcher_eastus2"
    network_watcher_rg_name  = "NetworkWatcherRG"
    retention_days           = "7"
    enable_traffic_analytics = false
    interval_in_minutes      = null # required only while using traffic analytics is enabled
  }
}

loganalytics_workspace_name = "jstartall02012022law"
