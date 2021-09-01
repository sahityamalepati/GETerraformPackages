resource "azurerm_dashboard" "aksdash" {
    for_each            = var.aks_dashboards
    name                = each.value["dashboardName"]
    resource_group_name = data.azurerm_resource_group.this.name
    location            = data.azurerm_resource_group.this.location

    tags = {
        source = "terraform"
    }

    dashboard_properties = <<DASH
    {
    "lenses": {
      "0": {
        "order": 0,
        "parts": {
          "0": {
            "position": {
              "x": 0,
              "y": 0,
              "colSpan": 11,
              "rowSpan": 1
            },
            "metadata": {
              "inputs": [],
              "type": "Extension/HubsExtension/PartType/MarkdownPart",
              "settings": {
                "content": {
                  "settings": {
                    "content": "\n",
                    "markdownSource": 1,
                    "subtitle": "This section outlines the CPU and Memory usage for the nodes within the cluster.",
                    "title": "Node Monitors"
                  }
                }
              }
            }
          },
          "1": {
            "position": {
              "x": 11,
              "y": 0,
              "colSpan": 2,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": {
                    "SubscriptionId": "${var.subscriptionId}",
                    "ResourceGroup": "${each.value["workspaceResourceGroup"]}",
                    "Name": "${each.value["workspaceName"]}",
                    "LinkedApplicationType": 2,
                    "ResourceId": "${each.value["workspaceResourceId"]}",
                    "ResourceType": "microsoft.operationalinsights/workspaces",
                    "IsAzureFirst": false
                  }
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["podWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "ViewerMode",
                  "value": false,
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "NotebookParams",
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "1.0",
                  "isOptional": true
                },
                {
                  "name": "ComponentId",
                  "value": {
                    "SubscriptionId": "${var.subscriptionId}",
                    "ResourceGroup": "${each.value["workspaceResourceGroup"]}",
                    "Name": "${each.value["workspaceName"]}",
                    "LinkedApplicationType": 2,
                    "ResourceId": "${each.value["workspaceResourceId"]}",
                    "ResourceType": "microsoft.operationalinsights/workspaces",
                    "IsAzureFirst": false
                  }
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["podWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "ViewerMode",
                  "value": false,
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "NotebookParams",
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "1.0",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/NotebookPinnedPart",
              "viewState": {
                "content": {
                  "configurationId": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["podWorkbookName"]}"
                }
              }
            }
          },
          "2": {
            "position": {
              "x": 14,
              "y": 0,
              "colSpan": 2,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": {
                    "SubscriptionId": "${var.subscriptionId}",
                    "ResourceGroup": "${each.value["workspaceResourceGroup"]}",
                    "Name": "${each.value["workspaceName"]}",
                    "LinkedApplicationType": 2,
                    "ResourceId": "${each.value["workspaceResourceId"]}",
                    "ResourceType": "microsoft.operationalinsights/workspaces",
                    "IsAzureFirst": false
                  }
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["namespaceWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "ViewerMode",
                  "value": false,
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "NotebookParams",
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "1.0",
                  "isOptional": true
                },
                {
                  "name": "ComponentId",
                  "value": {
                    "SubscriptionId": "${var.subscriptionId}",
                    "ResourceGroup": "${each.value["workspaceResourceGroup"]}",
                    "Name": "${each.value["workspaceName"]}",
                    "LinkedApplicationType": 2,
                    "ResourceId": "${each.value["workspaceResourceId"]}",
                    "ResourceType": "microsoft.operationalinsights/workspaces",
                    "IsAzureFirst": false
                  }
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["namespaceWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "ViewerMode",
                  "value": false,
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "NotebookParams",
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                },
                {
                  "name": "Version",
                  "value": "1.0",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/NotebookPinnedPart",
              "viewState": {
                "content": {
                  "configurationId": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["namespaceWorkbookName"]}"
                }
              }
            }
          },
          "3": {
            "position": {
              "x": 0,
              "y": 1,
              "colSpan": 11,
              "rowSpan": 4
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": "${each.value["workspaceResourceId"]}",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "value": null,
                  "isOptional": true
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["nodeWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "PinName",
                  "value": "Workbook 1",
                  "isOptional": true
                },
                {
                  "name": "StepSettings",
                  "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"let endDateTime = {timeRange:end};\\nlet startDateTime = {timeRange:start};\\nlet trendBinSize = {timeRange:grain};\\nlet capacityCounterName = 'cpuLimitNanoCores';\\nlet usageCounterName = 'cpuUsageNanoCores';\\nlet maxOn = indexof(\\\"{cpuAggregation}\\\", 'Max');\\nlet avgOn = indexof(\\\"{cpuAggregation}\\\", 'Avg');\\nlet minOn = indexof(\\\"{cpuAggregation}\\\", 'Min');\\nKubePodInventory\\n| where TimeGenerated < endDateTime\\n| where TimeGenerated >= startDateTime\\n{clusterNameWhereClause}\\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\\n         ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),\\n         PodName = Name\\n| distinct Computer, InstanceName, ContainerName, PodName\\n| join hint.strategy=shuffle (\\n    Perf\\n    | where TimeGenerated < endDateTime\\n    | where TimeGenerated >= startDateTime\\n    | where ObjectName == 'K8SContainer'\\n    | where CounterName == capacityCounterName\\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)\\n    | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue, limitA=100\\n) on Computer, InstanceName\\n| join kind=inner hint.strategy=shuffle (\\n    Perf\\n    | where TimeGenerated < endDateTime + trendBinSize\\n    | where TimeGenerated >= startDateTime - trendBinSize\\n    | where ObjectName == 'K8SContainer'\\n    | where CounterName == usageCounterName\\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\\n) on Computer, InstanceName\\n| where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime\\n| project  ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue,Computer\\n| summarize AggregatedValue= iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize),Computer\\n\",\"size\":3,\"aggregation\":3,\"showAnalytics\":true,\"title\":\"CPU Usage by Node\",\"timeContext\":{\"durationMs\":86400000},\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"visualization\":\"timechart\",\"chartSettings\":{\"showLegend\":true,\"showMetrics\":false,\"ySettings\":{\"max\":100,\"min\":0}}}",
                  "isOptional": true
                },
                {
                  "name": "ParameterValues",
                  "value": {
                    "timeRange": {
                      "type": 4,
                      "value": {
                        "durationMs": 86400000,
                        "createdTime": "2020-07-27T22:23:09.337Z",
                        "isInitialTime": false,
                        "grain": 1,
                        "useDashboardTimeRange": false
                      },
                      "formattedValue": "Last 24 hours",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "Last 24 hours",
                      "displayName": "Time Range"
                    },
                    "clusterName": {
                      "type": 2,
                      "value": [],
                      "formattedValue": "",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "<unset>",
                      "displayName": "Cluster Name"
                    },
                    "clusterNameWhereClause": {
                      "type": 1,
                      "value": "| where 'a' == 'a'",
                      "formattedValue": "| where 'a' == 'a'",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "| where 'a' == 'a'",
                      "displayName": "clusterNameWhereClause"
                    },
                    "cpuAggregation": {
                      "type": 10,
                      "value": "Average",
                      "formattedValue": "Average",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "Average",
                      "displayName": "CPU Aggregation"
                    }
                  },
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
            }
          },
          "4": {
            "position": {
              "x": 11,
              "y": 2,
              "colSpan": 6,
              "rowSpan": 4
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": "${each.value["workspaceResourceId"]}",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "value": null,
                  "isOptional": true
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "/subscriptions/${var.subscriptionId}/resourcegroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooks/${each.value["nodeWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "PinName",
                  "value": "Workbook 1",
                  "isOptional": true
                },
                {
                  "name": "StepSettings",
                  "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"KubeNodeInventory\\r\\n{clusterNameWhereClause}\\r\\n| summarize arg_max(TimeGenerated, *) by Computer\\r\\n| summarize count() by ClusterName\\r\\n| render piechart\\r\\n\",\"size\":0,\"showAnalytics\":true,\"title\":\"Node Availability \",\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"visualization\":\"piechart\",\"tileSettings\":{\"showBorder\":false}}",
                  "isOptional": true
                },
                {
                  "name": "ParameterValues",
                  "value": {
                    "clusterName": {
                      "type": 2,
                      "value": [],
                      "formattedValue": "",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "<unset>",
                      "displayName": "Cluster Name"
                    },
                    "clusterNameWhereClause": {
                      "type": 1,
                      "value": "| where 'a' == 'a'",
                      "formattedValue": "| where 'a' == 'a'",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "| where 'a' == 'a'",
                      "displayName": "clusterNameWhereClause"
                    }
                  },
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "value": "northcentralus",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
            }
          },
          "5": {
            "position": {
              "x": 0,
              "y": 5,
              "colSpan": 11,
              "rowSpan": 4
            },
            "metadata": {
              "inputs": [
                {
                  "name": "ComponentId",
                  "value": "${each.value["workspaceResourceId"]}",
                  "isOptional": true
                },
                {
                  "name": "TimeContext",
                  "value": null,
                  "isOptional": true
                },
                {
                  "name": "ResourceIds",
                  "value": [
                    "${each.value["workspaceResourceId"]}"
                  ],
                  "isOptional": true
                },
                {
                  "name": "ConfigurationId",
                  "value": "ArmTemplates-/subscriptions/${var.subscriptionId}/resourceGroups/${each.value["workspaceResourceGroup"]}/providers/microsoft.insights/workbooktemplates/${each.value["nodeWorkbookName"]}",
                  "isOptional": true
                },
                {
                  "name": "Type",
                  "value": "workbook",
                  "isOptional": true
                },
                {
                  "name": "GalleryResourceType",
                  "value": "microsoft.operationalinsights/workspaces",
                  "isOptional": true
                },
                {
                  "name": "PinName",
                  "value": "Workbook 1",
                  "isOptional": true
                },
                {
                  "name": "StepSettings",
                  "value": "{\"version\":\"KqlItem/1.0\",\"query\":\"let endDateTime = {timeRange:end};\\nlet startDateTime = {timeRange:start};\\nlet trendBinSize = {timeRange:grain};\\nlet capacityCounterName = 'memoryLimitBytes';\\nlet usageCounterName = 'memoryRssBytes';\\nlet maxOn = indexof(\\\"{memoryAggregation}\\\", 'Max');\\nlet avgOn = indexof(\\\"{memoryAggregation}\\\", 'Avg');\\nlet minOn = indexof(\\\"{memoryAggregation}\\\", 'Min');\\nKubePodInventory\\n| where TimeGenerated < endDateTime\\n| where TimeGenerated >= startDateTime\\n{clusterNameWhereClause}\\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\\n         ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),\\n         PodName=Name\\n| distinct Computer, InstanceName, ContainerName\\n| join hint.strategy=shuffle (\\n    Perf\\n    | where TimeGenerated < endDateTime\\n    | where TimeGenerated >= startDateTime\\n    | where ObjectName == 'K8SContainer'\\n    | where CounterName == capacityCounterName\\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)\\n    | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue\\n) on Computer, InstanceName\\n| join kind=inner hint.strategy=shuffle (\\n    Perf\\n    | where TimeGenerated < endDateTime + trendBinSize\\n    | where TimeGenerated >= startDateTime - trendBinSize\\n    | where ObjectName == 'K8SContainer'\\n    | where CounterName == usageCounterName\\n    | project Computer, InstanceName, UsageValue = CounterValue, TimeGenerated\\n) on Computer, InstanceName\\n| where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime\\n| project Computer, ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\\n| summarize AggregatedValue = iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize) , Computer\\n\",\"size\":3,\"aggregation\":3,\"showAnalytics\":true,\"title\":\"Memory Usage by Node\",\"timeContext\":{\"durationMs\":86400000},\"queryType\":0,\"resourceType\":\"microsoft.operationalinsights/workspaces\",\"visualization\":\"timechart\",\"chartSettings\":{\"showLegend\":true,\"showMetrics\":false,\"ySettings\":{\"max\":100,\"min\":0}}}",
                  "isOptional": true
                },
                {
                  "name": "ParameterValues",
                  "value": {
                    "timeRange": {
                      "type": 4,
                      "value": {
                        "durationMs": 86400000,
                        "createdTime": "2020-07-27T22:23:09.337Z",
                        "isInitialTime": false,
                        "grain": 1,
                        "useDashboardTimeRange": false
                      },
                      "formattedValue": "Last 24 hours",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "Last 24 hours",
                      "displayName": "Time Range"
                    },
                    "clusterName": {
                      "type": 2,
                      "value": [],
                      "formattedValue": "",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "<unset>",
                      "displayName": "Cluster Name"
                    },
                    "clusterNameWhereClause": {
                      "type": 1,
                      "value": "| where 'a' == 'a'",
                      "formattedValue": "| where 'a' == 'a'",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "| where 'a' == 'a'",
                      "displayName": "clusterNameWhereClause"
                    },
                    "cpuAggregation": {
                      "type": 10,
                      "value": "Average",
                      "formattedValue": "Average",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "Average",
                      "displayName": "CPU Aggregation"
                    },
                    "memoryAggregation": {
                      "type": 10,
                      "value": "Average",
                      "formattedValue": "Average",
                      "isPending": false,
                      "isWaiting": false,
                      "isFailed": false,
                      "labelValue": "Average",
                      "displayName": "Memory Aggregation"
                    }
                  },
                  "isOptional": true
                },
                {
                  "name": "Location",
                  "isOptional": true
                }
              ],
              "type": "Extension/AppInsightsExtension/PartType/PinnedNotebookQueryPart"
            }
          }
        }
      }
    },
    "metadata": {
      "model": {
        "timeRange": {
          "value": {
            "relative": {
              "duration": 24,
              "timeUnit": 1
            }
          },
          "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
        },
        "filterLocale": {
          "value": "en-us"
        },
        "filters": {
          "value": {
            "MsPortalFx_TimeRange": {
              "model": {
                "format": "utc",
                "granularity": "auto",
                "relative": "24h"
              },
              "displayCache": {
                "name": "UTC Time",
                "value": "Past 24 hours"
              },
              "filteredPartIds": [
                "StartboardPart-PinnedNotebookQueryPart-3a66039d-d192-4ed1-baf6-b0efa10ddcda",
                "StartboardPart-ChartPart-3a66039d-d192-4ed1-baf6-b0efa10ddd63",
                "StartboardPart-ChartPart-3a66039d-d192-4ed1-baf6-b0efa10ddd6d"
              ]
            }
          }
        }
      }
    }
  }
    DASH
}

output "aks_dashboard_ids" {
    value = [for x in azurerm_dashboard.aksdash : x.id]
}