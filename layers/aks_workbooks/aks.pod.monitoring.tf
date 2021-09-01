resource "azurerm_template_deployment" "akspodwb" {
    for_each                = var.aks_pod_workbooks
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
      "defaultValue": "workbook-display-name",
      "metadata": {
        "description": "The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
      }
    },
    "workbookSourceId": {
      "type": "string",
      "defaultValue": "workbook-source-id",
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
      "kind": "shared",
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
      "type": 1,
      "content": {
        "json": ""
      },
      "name": "text - 13"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "e2b5cd30-7276-477f-a6bb-07da25ba5e5f",
            "version": "KqlParameterItem/1.0",
            "name": "timeRange",
            "label": "Time Range",
            "type": 4,
            "description": "Filter data by time range",
            "isRequired": true,
            "value": {
              "durationMs": 300000
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
            "id": "9767de49-ba31-4847-9ffc-714c02e7523c",
            "version": "KqlParameterItem/1.0",
            "name": "clusterId",
            "label": "Cluster Name",
            "type": 2,
            "description": "Filter the selected workspace by cluster id",
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "KubePodInventory\n| distinct ClusterName\n| order by ClusterName asc\n| project ClusterName\n",
            "crossComponentResources": [],
            "value": [],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "cba109cf-db6e-4261-8d3a-fe038593622d",
            "version": "KqlParameterItem/1.0",
            "name": "clusterIdWhereClause",
            "type": 1,
            "description": "use this to filter by clusterid ",
            "value": "| where \"a\" == \"a\"",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (clusterId is not empty ), result = '| where ClusterName in ({clusterId})'",
                "criteriaContext": {
                  "leftOperand": "clusterId",
                  "operator": "isNotNull",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where ClusterName in ({clusterId})"
                }
              },
              {
                "condition": "else result = '| where \"a\" == \"a\"'",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where \"a\" == \"a\""
                }
              }
            ]
          },
          {
            "id": "ee080bd8-83dc-4fa0-b688-b2f16b956b92",
            "version": "KqlParameterItem/1.0",
            "name": "workloadType",
            "label": "Workload Type",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n| order by ControllerKind asc\n| distinct ControllerKind",
            "crossComponentResources": [],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces",
            "value": []
          },
          {
            "id": "cf611d4b-aa93-4949-a7a1-c1d174af29ca",
            "version": "KqlParameterItem/1.0",
            "name": "workloadKindWhereClause",
            "type": 1,
            "value": "| where \"a\" == \"a\"",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (workloadType is not empty ), result = '| where ControllerKind in ({workloadType})'",
                "criteriaContext": {
                  "leftOperand": "workloadType",
                  "operator": "isNotNull",
                  "rightValType": "static",
                  "rightVal": "unset",
                  "resultValType": "static",
                  "resultVal": "| where ControllerKind in ({workloadType})"
                }
              },
              {
                "condition": "else result = '| where \"a\" == \"a\"'",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where \"a\" == \"a\""
                }
              }
            ],
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "034caae5-bee3-4b66-8f80-c120a2a25c77",
            "version": "KqlParameterItem/1.0",
            "name": "namespace",
            "label": "Namespace",
            "type": 2,
            "description": "Filter the workbook by namespace",
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{workloadKindWhereClause}\r\n| order by Namespace asc\n| distinct Namespace",
            "value": [],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "faeee248-e4c3-4fae-b435-ef5fb6dabe3b",
            "version": "KqlParameterItem/1.0",
            "name": "namespaceWhereClause",
            "type": 1,
            "value": "| where \"a\" == \"a\"",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (namespace is not empty ), result = '| where Namespace in ({namespace})'",
                "criteriaContext": {
                  "leftOperand": "namespace",
                  "operator": "isNotNull",
                  "rightValType": "static",
                  "rightVal": "unset",
                  "resultValType": "static",
                  "resultVal": "| where Namespace in ({namespace})"
                }
              },
              {
                "condition": "else result = '| where \"a\" == \"a\"'",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where \"a\" == \"a\""
                }
              }
            ],
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "e45eb37a-20d2-4b45-aec1-dd62d0d54069",
            "version": "KqlParameterItem/1.0",
            "name": "workloadName",
            "label": "Controller",
            "type": 2,
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadKindWhereClause}\r\n| order by ControllerName asc\r\n| distinct ControllerName",
            "value": [],
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "86f25a45-0ad7-4507-9194-6fb1871ffbc3",
            "version": "KqlParameterItem/1.0",
            "name": "workloadNameWhereClause",
            "type": 1,
            "value": "| where 'a'=='a'",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (workloadName is not empty ), result = '| where ControllerName in ({workloadName})'",
                "criteriaContext": {
                  "leftOperand": "workloadName",
                  "operator": "isNotNull",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where ControllerName in ({workloadName})"
                }
              },
              {
                "condition": "else result = '| where 'a'=='a''",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where 'a'=='a'"
                }
              }
            ],
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "00a9be6c-ab0b-400b-b195-9775a47ecddd",
            "version": "KqlParameterItem/1.0",
            "name": "podStatus",
            "label": "Pod Status",
            "type": 2,
            "description": "Filter by Pod status like Pending/Running/Failed etc.",
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| order by PodStatus asc\r\n| distinct PodStatus",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "388ea6aa-12d8-485a-8e80-b4d7b8994bd8",
            "version": "KqlParameterItem/1.0",
            "name": "podStatusWhereClause",
            "type": 1,
            "value": "| where \"a\" == \"a\"",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (podStatus is not empty ), result = '| where PodStatus in ({podStatus})'",
                "criteriaContext": {
                  "leftOperand": "podStatus",
                  "operator": "isNotNull",
                  "rightValType": "static",
                  "rightVal": "unset",
                  "resultValType": "static",
                  "resultVal": "| where PodStatus in ({podStatus})"
                }
              },
              {
                "condition": "else result = '| where \"a\" == \"a\"'",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where \"a\" == \"a\""
                }
              }
            ],
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "64de23e6-96b5-4105-b65d-36e40f73f4ec",
            "version": "KqlParameterItem/1.0",
            "name": "podName",
            "label": "Pod Name",
            "type": 2,
            "description": "Filter by pod name ",
            "multiSelect": true,
            "quote": "'",
            "delimiter": ",",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n{podStatusWhereClause}\r\n| order by Name asc\r\n| summarize arg_max(TimeGenerated, PodStatus) by Name\r\n| project Name",
            "typeSettings": {
              "additionalResourceOptions": []
            },
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "4f7059c2-ebd7-4fc2-86c4-c51e66703582",
            "version": "KqlParameterItem/1.0",
            "name": "podNameWhereClause",
            "type": 1,
            "value": "| where \"a\" == \"a\"",
            "isHiddenWhenLocked": true,
            "criteriaData": [
              {
                "condition": "if (podName is not empty ), result = '| where PodName in ({podName})'",
                "criteriaContext": {
                  "leftOperand": "podName",
                  "operator": "isNotNull",
                  "rightValType": "static",
                  "rightVal": "unset",
                  "resultValType": "static",
                  "resultVal": "| where PodName in ({podName})"
                }
              },
              {
                "condition": "else result = '| where \"a\" == \"a\"'",
                "criteriaContext": {
                  "operator": "Default",
                  "rightValType": "param",
                  "resultValType": "static",
                  "resultVal": "| where \"a\" == \"a\""
                }
              }
            ],
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange"
          },
          {
            "id": "e60298ff-36da-485e-acea-73c0692b8446",
            "version": "KqlParameterItem/1.0",
            "name": "workloadNameSpace",
            "type": 1,
            "description": "for displaying name space of the selected workload",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| distinct Namespace\r\n| project tostring(Namespace)",
            "isHiddenWhenLocked": true,
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          },
          {
            "id": "9f8d0d65-d7bc-42c9-bc5c-b394288b5216",
            "version": "KqlParameterItem/1.0",
            "name": "workloadTypeText",
            "type": 1,
            "description": "for displaying workload type of the selected workload",
            "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| distinct ControllerKind\r\n| project tostring(ControllerKind)",
            "isHiddenWhenLocked": true,
            "timeContext": {
              "durationMs": 0
            },
            "timeContextFromParameter": "timeRange",
            "queryType": 0,
            "resourceType": "microsoft.operationalinsights/workspaces"
          }
        ],
        "style": "above",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "dropwdowns"
    },
    {
      "type": 1,
      "content": {
        "json": "<h3>\r\nWorkload: {workloadName}\r\n</h3>\r\n<h5>\r\nWorkload Type: {workloadTypeText}\r\n</h5>\r\n<h5>\r\nNamespace: {workloadNameSpace}\r\n</h5>"
      },
      "conditionalVisibility": {
        "parameterName": "workloadNameSpace",
        "comparison": "isNotEqualTo",
        "value": ""
      },
      "name": "text - 10",
      "styleSettings": {
        "margin": "0 0 0 0",
        "padding": "0px",
        "progressStyle": "loader"
      }
    },
    {
      "type": 1,
      "content": {
        "json": "<br/>\r\n<div style=\"border: 1px solid grey\"></div>\r\n<br/>\r\n"
      },
      "name": "text - 20 - Copy"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "3b1d8e34-588d-4c66-8d10-95f3352f70ac",
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
            "timeContextFromParameter": "timeRange"
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "parameters - 15"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\nlet startDateTime = {timeRange:start};\r\nlet trendBinSize = {timeRange:grain};\r\nlet capacityCounterName = 'cpuLimitNanoCores';\r\nlet usageCounterName = 'cpuUsageNanoCores';\r\nlet maxOn = indexof(\"{cpuAggregation}\", 'Max');\r\nlet avgOn = indexof(\"{cpuAggregation}\", 'Avg');\r\nlet minOn = indexof(\"{cpuAggregation}\", 'Min');\r\nKubePodInventory\r\n| where TimeGenerated < endDateTime\r\n| where TimeGenerated >= startDateTime\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\r\n         ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),\r\n         PodName = Name\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| distinct Computer, InstanceName, ContainerName, PodName\r\n| join hint.strategy=shuffle (\r\n    Perf\r\n    | where TimeGenerated < endDateTime\r\n    | where TimeGenerated >= startDateTime\r\n    | where ObjectName == 'K8SContainer'\r\n    | where CounterName == capacityCounterName\r\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)\r\n    | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue, limitA=100\r\n) on Computer, InstanceName\r\n| join kind=inner hint.strategy=shuffle (\r\n    Perf\r\n    | where TimeGenerated < endDateTime + trendBinSize\r\n    | where TimeGenerated >= startDateTime - trendBinSize\r\n    | where ObjectName == 'K8SContainer'\r\n    | where CounterName == usageCounterName\r\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\r\n) on Computer, InstanceName\r\n| where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime\r\n| project  ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue, PodName\r\n| summarize AggregatedValue= iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize), PodName",
        "size": 3,
        "aggregation": 3,
        "showAnalytics": true,
        "title": "CPU usage by PODs",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "timechart",
        "chartSettings": {
          "showMetrics": false,
          "showLegend": true,
          "ySettings": {
            "min": 0,
            "max": 100
          }
        }
      },
      "showPin": true,
      "name": "cpuChart",
      "styleSettings": {
        "padding": "10px",
        "showBorder": true
      }
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "3edacd40-5542-4e1b-b9c2-0860310dbfcc",
            "version": "KqlParameterItem/1.0",
            "name": "memAggregation",
            "label": "Memory Aggregation",
            "type": 10,
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
      "name": "parameters - 14"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\nlet startDateTime = {timeRange:start};\r\nlet trendBinSize = {timeRange:grain};\r\nlet capacityCounterName = 'memoryLimitBytes';\r\nlet usageCounterName = 'memoryRssBytes';\r\nlet maxOn = indexof(\"{memAggregation}\", 'Max');\r\nlet avgOn = indexof(\"{memAggregation}\", 'Avg');\r\nlet minOn = indexof(\"{memAggregation}\", 'Min');\r\nKubePodInventory\r\n| where TimeGenerated < endDateTime\r\n| where TimeGenerated >= startDateTime\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\r\n         ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),\r\n         PodName=Name\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| distinct Computer, InstanceName, ContainerName, PodName\r\n| join hint.strategy=shuffle (\r\n    Perf\r\n    | where TimeGenerated < endDateTime\r\n    | where TimeGenerated >= startDateTime\r\n    | where ObjectName == 'K8SContainer'\r\n    | where CounterName == capacityCounterName\r\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)\r\n    | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue\r\n) on Computer, InstanceName\r\n| join kind=inner hint.strategy=shuffle (\r\n    Perf\r\n    | where TimeGenerated < endDateTime + trendBinSize\r\n    | where TimeGenerated >= startDateTime - trendBinSize\r\n    | where ObjectName == 'K8SContainer'\r\n    | where CounterName == usageCounterName\r\n    | project Computer, InstanceName, UsageValue = CounterValue, TimeGenerated\r\n) on Computer, InstanceName\r\n| where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime\r\n| project Computer, ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue, PodName\r\n| summarize AggregatedValue = iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize) , PodName\r\n",
        "size": 3,
        "aggregation": 3,
        "showAnalytics": true,
        "title": "Memory usage by PODs",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "timechart",
        "chartSettings": {
          "showMetrics": false,
          "showLegend": true
        }
      },
      "showPin": true,
      "name": "memChart",
      "styleSettings": {
        "margin": "0px",
        "padding": "10px",
        "showBorder": true
      }
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "KubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| extend PodName = Name\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| summarize arg_max(TimeGenerated, *) by Name\r\n| summarize count() by PodStatus \r\n| render piechart",
        "size": 0,
        "showAnalytics": true,
        "title": "POD status",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "customWidth": "50",
      "showPin": true,
      "name": "3"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\n    let startDateTime = {timeRange:start};\r\n    let trendBinSize = {timeRange:grain};\r\n    KubePodInventory\r\n    | where TimeGenerated < endDateTime\r\n    | where TimeGenerated >= startDateTime\r\n    | distinct ClusterName, TimeGenerated\r\n    | summarize ClusterSnapshotCount = count() by bin(TimeGenerated, trendBinSize), ClusterName\r\n    | join hint.strategy=broadcast (\r\n        KubePodInventory\r\n        | where TimeGenerated < endDateTime\r\n        | where TimeGenerated >= startDateTime\r\n        {clusterIdWhereClause}\r\n        {namespaceWhereClause}\r\n        {workloadNameWhereClause}\r\n        | extend PodName = Name\r\n        {podStatusWhereClause}\r\n        {podNameWhereClause}\r\n        | distinct ClusterName, Computer, PodUid, TimeGenerated, PodStatus\r\n        | summarize TotalCount = count(), //Calculating count for per pod status\r\n                    PendingCount = sumif(1, PodStatus =~ 'Pending'),\r\n                    RunningCount = sumif(1, PodStatus =~ 'Running'),\r\n                    SucceededCount = sumif(1, PodStatus =~ 'Succeeded'),\r\n                    FailedCount = sumif(1, PodStatus =~ 'Failed')\r\n                 by ClusterName, bin(TimeGenerated, trendBinSize)\r\n    ) on ClusterName, TimeGenerated\r\n    | extend UnknownCount = TotalCount - PendingCount - RunningCount - SucceededCount - FailedCount\r\n    | project TimeGenerated,\r\n    TotalCount = todouble(TotalCount) / ClusterSnapshotCount,\r\n              PendingCount = todouble(PendingCount) / ClusterSnapshotCount,\r\n              RunningCount = todouble(RunningCount) / ClusterSnapshotCount,\r\n              SucceededCount = todouble(SucceededCount) / ClusterSnapshotCount,\r\n              FailedCount = todouble(FailedCount) / ClusterSnapshotCount,\r\n              UnknownCount = todouble(UnknownCount) / ClusterSnapshotCount",
        "size": 0,
        "aggregation": 5,
        "showAnalytics": true,
        "title": "POD status trend",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "linechart"
      },
      "customWidth": "50",
      "showPin": true,
      "name": "6",
      "styleSettings": {
        "showBorder": true
      }
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\nlet startDateTime = {timeRange:start};\r\nlet trendBinSize = {timeRange:grain};\r\nKubePodInventory\r\n| where TimeGenerated >= startDateTime\r\n| where TimeGenerated < endDateTime\r\n{clusterIdWhereClause}\r\n| where isnotempty(ClusterName)\r\n| where isnotempty(Namespace)\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| extend PodName = Name\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| summarize PodRestartCount=max(PodRestartCount) by PodName, bin(TimeGenerated, trendBinSize)\r\n| order by PodName asc nulls last, TimeGenerated asc\r\n| serialize \r\n| extend prevValue=iif(prev(PodName) == PodName, prev(PodRestartCount), PodRestartCount)\r\n| extend RestartCount=PodRestartCount - prevValue\r\n| extend RestartCount=iif(RestartCount < 0, 0, RestartCount) \r\n| project TimeGenerated, PodName, RestartCount\r\n| render timechart",
        "size": 0,
        "aggregation": 5,
        "showAnalytics": true,
        "title": "POD restart trend",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "timechart"
      },
      "customWidth": "50",
      "showPin": true,
      "name": "5",
      "styleSettings": {
        "showBorder": true
      }
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\nlet startDateTime = {timeRange:start};\r\nlet trendBinSize = {timeRange:grain};\r\nKubePodInventory\r\n| where TimeGenerated >= startDateTime\r\n| where TimeGenerated < endDateTime\r\n{clusterIdWhereClause}\r\n| where isnotempty(ClusterName)\r\n| where isnotempty(Namespace)\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| extend PodName = Name\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| extend ContainerName=tostring(split(ContainerName, '/')[1])\r\n| where isempty(ContainerName) == false\r\n| summarize ContainerRestartCount=sum(ContainerRestartCount) by ContainerName, bin(TimeGenerated, 1tick)\r\n| order by ContainerName asc nulls last, TimeGenerated asc\r\n| serialize \r\n| extend prevValue=iif(prev(ContainerName) == ContainerName, prev(ContainerRestartCount), ContainerRestartCount)\r\n| extend RestartCount=ContainerRestartCount - prevValue\r\n| extend RestartCount=iif(RestartCount < 0, 0, RestartCount) \r\n| project TimeGenerated, ContainerName, RestartCount\r\n| summarize RestartCount=sum(RestartCount) by ContainerName, bin(TimeGenerated, trendBinSize)",
        "size": 0,
        "aggregation": 5,
        "showAnalytics": true,
        "title": "Container restart trend",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "timechart"
      },
      "customWidth": "50",
      "showPin": true,
      "name": "Query - 5",
      "styleSettings": {
        "showBorder": true
      }
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\nlet startDateTime = {timeRange:start};\r\nlet trendBinSize = {timeRange:grain};\r\nKubePodInventory\r\n| where TimeGenerated >= startDateTime\r\n| where TimeGenerated < endDateTime\r\n{clusterIdWhereClause}\r\n| where isnotempty(ClusterName)\r\n| where isnotempty(Namespace)\r\n| extend PodName = Name\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\r\n         ContainerName = strcat(Name, '/', tostring(split(ContainerName, '/')[1]))\r\n| summarize arg_max(TimeGenerated, *) by ContainerName, Name| extend ContainerLastStatus = todynamic(ContainerStatus) \r\n| project TimeGenerated, ContainerName, PodName, PodStatus, ContainerStatus, LastState=ContainerLastStatus.lastState, LastStateReason=ContainerLastStatus.reason, LastStateStartTime=ContainerLastStatus.startedAt,\r\nLastStateFinishTime=ContainerLastStatus.finishedAt\r\n",
        "size": 0,
        "aggregation": 5,
        "showAnalytics": true,
        "title": "Latest container status for PODs",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "gridSettings": {
          "formatters": [
            {
              "columnMatch": "LastStateStartTime",
              "formatter": 6,
              "formatOptions": {}
            },
            {
              "columnMatch": "LastStateFinishTime",
              "formatter": 6,
              "formatOptions": {}
            }
          ],
          "sortBy": [
            {
              "itemKey": "PodStatus",
              "sortOrder": 2
            }
          ]
        },
        "sortBy": [
          {
            "itemKey": "PodStatus",
            "sortOrder": 2
          }
        ]
      },
      "showPin": true,
      "name": "Query - 6"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\r\nlet startDateTime = {timeRange:start};\r\nlet trendBinSize = {timeRange:grain};\r\nKubePodInventory\r\n| where TimeGenerated >= startDateTime\r\n| where TimeGenerated < endDateTime\r\n{clusterIdWhereClause}\r\n| where isnotempty(ClusterName)\r\n| where isnotempty(Namespace)\r\n| extend PodName = Name\r\n{namespaceWhereClause}\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| join (KubeEvents\r\n| where TimeGenerated >= startDateTime\r\n| where TimeGenerated < endDateTime)\r\non Name, $left.Name == $right.Name\r\n{workloadNameWhereClause}\r\n| project TimeGenerated, PodName=Name,Reason, EventMessage=Message, NodeName=Computer\r\n",
        "size": 0,
        "aggregation": 5,
        "showAnalytics": true,
        "title": "Kube Events for the controller",
        "noDataMessage": "There are no kube events for the selected criteria",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "table"
      },
      "showPin": true,
      "name": "7"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let trendBinSize = {timeRange:grain};\r\nKubePodInventory\r\n{clusterIdWhereClause}\r\n{namespaceWhereClause}\r\n{workloadNameWhereClause}\r\n| join KubeEvents\r\non Name, $left.Name == $right.Name\r\n| extend PodName = Name\r\n{podStatusWhereClause}\r\n{podNameWhereClause}\r\n| summarize count() by bin(TimeGenerated,trendBinSize), Reason \r\n\r\n",
        "size": 4,
        "showAnalytics": true,
        "title": "Kube Events Summary",
        "noDataMessage": "There are no Kube events for the selected criteria",
        "timeContext": {
          "durationMs": 300000
        },
        "timeContextFromParameter": "timeRange",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "piechart"
      },
      "customWidth": "25",
      "showPin": true,
      "name": "4"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "let endDateTime = {timeRange:end};\nlet startDateTime = {timeRange:start};\nlet trendBinSize = {timeRange:grain};\nKubePodInventory\n    {clusterIdWhereClause}\n    {namespaceWhereClause}\n    {workloadNameWhereClause}\n    | extend PodName = Name\n    {podNameWhereClause}\n    | distinct Computer\n    | project Computer\n    | join ( \n    InsightsMetrics\n    | where TimeGenerated >= startDateTime\n| where TimeGenerated < endDateTime\n| where Origin == 'container.azm.ms/telegraf'\n| where Namespace == 'container.azm.ms/disk'\n| extend Tags = todynamic(Tags)\n| project TimeGenerated, ClusterId = tostring(Tags['container.azm.ms/clusterId']), Computer = tostring(Tags.hostName), Device = tostring(Tags.device), Path = tostring(Tags.path), DiskMetricName = Name,  DiskMetricValue = Val\n) on Computer\n| where DiskMetricName == 'used_percent'\n| summarize Percent_Used = avg(bin(todouble(DiskMetricValue), 0.01)) by bin(TimeGenerated, trendBinSize), Computer, Device, Path",
        "size": 0,
        "showAnalytics": true,
        "title": "Pod Disk Storage Usage",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces",
        "visualization": "table",
        "gridSettings": {
          "formatters": [
            {
              "columnMatch": "TimeGenerated",
              "formatter": 5
            }
          ],
          "hierarchySettings": {
            "treeType": 1,
            "groupBy": [
              "TimeGenerated"
            ],
            "expandTopLevel": true
          }
        },
        "tileSettings": {
          "titleContent": {
            "columnMatch": "Computer",
            "formatter": 1,
            "formatOptions": {}
          },
          "leftContent": {
            "columnMatch": "Path",
            "formatter": 1,
            "formatOptions": {}
          },
          "rightContent": {
            "columnMatch": "Percent_Used",
            "formatter": 8,
            "formatOptions": {
              "min": 0,
              "max": 100,
              "palette": "red"
            }
          },
          "secondaryContent": {
            "columnMatch": "Device",
            "formatOptions": {}
          },
          "showBorder": false,
          "sortCriteriaField": "Percent_Used",
          "sortOrderField": 2
        },
        "mapSettings": {
          "locInfo": "LatLong",
          "sizeSettings": "Percent_Used",
          "sizeAggregation": "Sum",
          "legendMetric": "Percent_Used",
          "legendAggregation": "Sum",
          "itemColorSettings": {
            "type": "heatmap",
            "colorAggregation": "Sum",
            "nodeColorField": "Percent_Used",
            "heatmapPalette": "greenRed"
          }
        }
      },
      "customWidth": "75",
      "showPin": true,
      "name": "query - 15"
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
    "workbookId": {
      "type": "string",
      "value": "[resourceId( 'microsoft.insights/workbooks', parameters('workbookName'))]"
    }
  },
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
}

    DEPLOY
}

output "aks_pod_workbooks_ids" {
    value = [for x in azurerm_template_deployment.akspodwb : x.id]
}