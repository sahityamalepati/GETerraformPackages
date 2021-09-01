resource "azurerm_template_deployment" "aksnswb" {
    for_each                = var.aks_ns_workbooks
    name                    = each.value["workbookName"]
    deployment_mode         = "Incremental"
    resource_group_name     = data.azurerm_resource_group.this.name

    parameters = {
        "workbookName"          = each.value["workbookName"]
        "workbookDisplayName"   = each.value["workbookDisplayName"]
        "workbookSourceId"      = each.value["workbookSourceId"]
    }

    template_body = <<DEPLOY

    {
    "contentVersion": "1.0.0.0",
    "parameters": {
      "workbookName": {
        "type": "string",
        "defaultValue": "<workbook_name>",
        "metadata": {
          "description": "The name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
        }
      },
      "workbookDisplayName": {
        "type": "string",
        "defaultValue": "<workbook_display_name>",
        "metadata": {
          "description": "The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
        }
      },
      "workbookSourceId": {
        "type": "string",
        "defaultValue": "<workbook_source_id>",
        "metadata": {
          "description": "The id of resource instance to which the workbook will be associated"
        }
      },
      "workbookId": {
        "type": "string",
        "defaultValue": "[newGuid()]",
        "metadata": {
          "description": "The unique guid for this workbook instance"
        }
      }
    },
    "resources": [
      {
        "name": "[parameters('workbookName')]",
        "type": "microsoft.insights/workbooktemplates",
        "location": "[resourceGroup().location]",
        "apiVersion": "2019-10-17-preview",
        "dependsOn": [],
        "properties": {
          "galleries": [
            {
              "name": "[parameters('workbookDisplayName')]",
              "category": "AKS Base Monitoring Package",
              "order": 100,
              "type": "workbook",
              "resourceType":"microsoft.operationalinsights/workspaces"
            }
          ],
          "templateData": {
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "6ae79bfb-83f7-491f-b658-54f619a7593f",
            "version": "KqlParameterItem/1.0",
            "name": "timeRange",
            "label": "Time Range",
            "type": 4,
            "isRequired": true,
            "value": {
              "durationMs": 1800000
            },
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 900000
                },
                {
                  "durationMs": 1800000
                },
                {
                  "durationMs": 3600000
                },
                {
                  "durationMs": 14400000
                },
                {
                  "durationMs": 43200000
                },
                {
                  "durationMs": 86400000
                },
                {
                  "durationMs": 172800000
                },
                {
                  "durationMs": 259200000
                },
                {
                  "durationMs": 604800000
                },
                {
                  "durationMs": 1209600000
                },
                {
                  "durationMs": 2419200000
                },
                {
                  "durationMs": 2592000000
                },
                {
                  "durationMs": 5184000000
                },
                {
                  "durationMs": 7776000000
                }
              ],
              "allowCustom": true
            }
          },
          {
            "id": "f24c0c2c-3e18-40d1-8e61-ee6ea112b0f0",
            "version": "KqlParameterItem/1.0",
            "name": "clusterName",
            "label": "Cluster Name",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "crossComponentResources": [],
            "query": "KubeNodeInventory\n| distinct ClusterName\n| order by ClusterName asc\n| project ClusterName",
            "value": [],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "c008e152-eebf-41ce-8c0e-420e9f4238e5",
            "version": "KqlParameterItem/1.0",
            "name": "clusterNameWhereClause",
            "type": 1,
            "value": "| where 'a' == 'a'",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (clusterName is not empty ), result = '| where ClusterName in ({clusterName})'",
                "criteriaContext": {
                  "leftOperand": "clusterName",
                  "operator": "isNotNull",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where ClusterName in ({clusterName})"
                }
              },
              {
                "condition": "else result = '| where 'a' == 'a''",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where 'a' == 'a'"
                }
              }
            ]
          },
          {
            "id": "111d0b91-79cc-4440-b93d-5d777fef6faf",
            "version": "KqlParameterItem/1.0",
            "name": "namespace",
            "label": "Namespace",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "crossComponentResources": [],
            "query": "KubePodInventory\n{clusterNameWhereClause}\n| distinct Namespace\n| order by Namespace asc\n| project Namespace",
            "value": "",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "d39c4b3d-beee-4073-a2ef-aaded89882c7",
            "version": "KqlParameterItem/1.0",
            "name": "namespaceWhereClause",
            "type": 1,
            "value": "",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (namespace is not empty ), result = '| where Namespace in ({namespace})'",
                "criteriaContext": {
                  "leftOperand": "namespace",
                  "operator": "isNotNull",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where Namespace in ({namespace})"
                }
              },
              {
                "condition": "else result = '| where 'a' == 'a''",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where 'a' == 'a'"
                }
              }
            ]
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "parameters - 0"
    },
    {
      "type": 1,
      "content": {
        "json": "<br/>\n<div style=\"border: 1px solid grey\"></div>\n<br/>"
      },
      "name": "text - 1"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "4eba3dda-6eaa-45f4-a486-4285e8539475",
            "version": "KqlParameterItem/1.0",
            "name": "cpuAggregation",
            "label": "CPU Aggregation",
            "type": 10,
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[string(json('[{\"label\": \"Max\", \"value\": \"Max\"},{ \"label\": \"Average\", \"value\": \"Average\", \"selected\": true},{ \"label\": \"Min\", \"value\": \"Min\"}]'))]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "value": "Min"
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.insights/components"
      },
      "customWidth": "50",
      "name": "parameters - 4"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "8bc8df5e-9a22-4bf5-b410-540ae2e8d548",
            "version": "KqlParameterItem/1.0",
            "name": "memoryAggregation",
            "label": "Memory Aggregation",
            "type": 10,
            "value": "Min",
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "jsonData": "[string(json('[{\"label\": \"Max\", \"value\": \"Max\"},{ \"label\": \"Average\", \"value\": \"Average\", \"selected\": true},{ \"label\": \"Min\", \"value\": \"Min\"}]'))]",
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "customWidth": "50",
      "name": "parameters - 5"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\nlet startDateTime = {timeRange:start};\nlet trendBinSize = {timeRange:grain};\nlet capacityCounterName = 'cpuCapacityNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet maxOn = indexof(\"{cpuAggregation}\", 'Max');\nlet avgOn = indexof(\"{cpuAggregation}\", 'Average');\nlet minOn = indexof(\"{cpuAggregation}\", 'Min');\nKubePodInventory\n| where TimeGenerated < endDateTime\n| where TimeGenerated >= startDateTime\n{clusterNameWhereClause}\n{namespaceWhereClause}\n| distinct ClusterName, Computer\n| join\n    hint.strategy=shuffle ( Perf\n    | where TimeGenerated < endDateTime\n    | where TimeGenerated >= startDateTime\n    | where ObjectName == 'K8SNode'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, CounterName, bin(TimeGenerated, trendBinSize)\n    | project Computer, CapacityStartTime = TimeGenerated, CapacityEndTime = TimeGenerated + trendBinSize, LimitValue\n)\non Computer\n| join kind=inner\n    hint.strategy=shuffle ( Perf\n    | where TimeGenerated < endDateTime + trendBinSize\n    | where TimeGenerated >= startDateTime - trendBinSize\n    | where ObjectName == 'K8SNode'\n    | where CounterName == usageCounterName\n    | project Computer, UsageValue = CounterValue, TimeGenerated\n)\non Computer\n| where TimeGenerated >= CapacityStartTime and TimeGenerated < CapacityEndTime\n| project ClusterName, Computer, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize AggregatedValue= iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize), ClusterName",
        "size": 0,
        "aggregation": 3,
        "title": "Namespace CPU Utilization",
        "timeContext": {
          "durationMs": 14400000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "linechart"
      },
      "customWidth": "50",
      "name": "query - 2"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\nlet startDateTime = {timeRange:start};\nlet trendBinSize = {timeRange:grain};\nlet capacityCounterName = 'memoryCapacityBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet maxOn = indexof(\"{memoryAggregation}\", 'Max');\nlet avgOn = indexof(\"{memoryAggregation}\", 'Average');\nlet minOn = indexof(\"{memoryAggregation}\", 'Min');\nKubePodInventory\n| where TimeGenerated < endDateTime\n| where TimeGenerated >= startDateTime\n{clusterNameWhereClause}\n{namespaceWhereClause}\n| distinct ClusterName, Computer\n| join hint.strategy=shuffle (\n  Perf\n  | where TimeGenerated < endDateTime\n  | where TimeGenerated >= startDateTime\n  | where ObjectName == 'K8SNode'\n  | where CounterName == capacityCounterName\n  | summarize LimitValue = max(CounterValue) by Computer, CounterName, bin(TimeGenerated, trendBinSize)\n  | project Computer, CapacityStartTime = TimeGenerated, CapacityEndTime = TimeGenerated + trendBinSize, LimitValue\n) on Computer\n| join kind=inner hint.strategy=shuffle (\n  Perf\n  | where TimeGenerated < endDateTime + trendBinSize\n  | where TimeGenerated >= startDateTime - trendBinSize\n  | where ObjectName == 'K8SNode'\n  | where CounterName == usageCounterName\n  | project Computer, UsageValue = CounterValue, TimeGenerated\n) on Computer\n| where TimeGenerated >= CapacityStartTime and TimeGenerated < CapacityEndTime\n| project ClusterName, Computer, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize AggregatedValue = iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize), ClusterName",
        "size": 0,
        "aggregation": 3,
        "title": "Namespace Memory Utilization",
        "timeContext": {
          "durationMs": 1800000
        },
        "timeContextFromParameter": "timeRange",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "linechart"
      },
      "customWidth": "50",
      "name": "query - 3"
    }
  ],
  "defaultResourceIds": [
    "${each.value["workbookSourceId"]}"
  ],
  "fallbackResourceIds": [
    "${each.value["workbookSourceId"]}"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}
          
        }
      }
    ],
    "outputs": {
      "workbookName": {
        "type": "string",
        "value": "[resourceId( 'microsoft.insights/workbooks', parameters('workbookName'))]"
      }
    },
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
  }

    DEPLOY
}

output "aks_ns_workbooks_ids" {
    value = [for x in azurerm_template_deployment.aksnswb : x.id]
}