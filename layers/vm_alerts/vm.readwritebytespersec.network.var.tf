variable "vm_readwritebytespersec_network_alert" {
  type = map(object({
    dataSourceId        = string
    actionGroupId       = string
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
    vmrwbsa1 = {
        dataSourceId        = "full_data_source_id"
        actionGroupId       = "full_action_group_id"
    }   
  }
}