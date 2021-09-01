resource "azurerm_template_deployment" "aksnodewb" {
    for_each                = var.aks_node_workbooks
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
                        "resourceType": "microsoft.operationalinsights/workspaces"
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
                                        "id": "2415445d-7e93-42c2-8295-a87c4c702176",
                                        "isRequired": true,
                                        "label": "Time Range",
                                        "name": "timeRange",
                                        "type": 4,
                                        "typeSettings": {
                                            "allowCustom": true,
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
                                            ]
                                        },
                                        "value": {
                                            "durationMs": 86400000
                                        },
                                        "version": "KqlParameterItem/1.0"
                                    },
                                    {
                                        "crossComponentResources": [],
                                        "delimiter": ",",
                                        "id": "292978fc-5932-4171-832e-499785103f8e",
                                        "label": "Cluster Name",
                                        "multiSelect": true,
                                        "name": "clusterName",
                                        "query": "KubeNodeInventory\r\n| distinct ClusterName\r\n| order by ClusterName asc\r\n| project ClusterName",
                                        "queryType": 0,
                                        "quote": "'",
                                        "resourceType": "microsoft.operationalinsights/workspaces",
                                        "type": 2,
                                        "typeSettings": {
                                            "additionalResourceOptions": []
                                        },
                                        "value": [],
                                        "version": "KqlParameterItem/1.0"
                                    },
                                    {
                                        "criteriaData": [
                                            {
                                                "condition": "if (clusterName is not empty ), result = '| where ClusterName in ({clusterName})'",
                                                "criteriaContext": {
                                                    "leftOperand": "clusterName",
                                                    "operator": "isNotNull",
                                                    "resultVal": "| where ClusterName in ({clusterName})",
                                                    "resultValType": "static",
                                                    "rightValType": "param"
                                                }
                                            },
                                            {
                                                "condition": "else result = '| where 'a' == 'a''",
                                                "criteriaContext": {
                                                    "operator": "Default",
                                                    "resultVal": "| where 'a' == 'a'",
                                                    "resultValType": "static",
                                                    "rightValType": "param"
                                                }
                                            }
                                        ],
                                        "id": "352c2cb3-474f-4b92-92a9-dc0b96435170",
                                        "isHiddenWhenLocked": true,
                                        "name": "clusterNameWhereClause",
                                        "type": 1,
                                        "value": "| where 'a' == 'a'",
                                        "version": "KqlParameterItem/1.0"
                                    }
                                ],
                                "style": "above",
                                "queryType": 0,
                                "resourceType": "microsoft.operationalinsights/workspaces"
                            },
                            "name": "parameters - 1"
                        },
                        {
                            "type": 1,
                            "content": {
                                "json": "<br/>\r\n<div style=\"border: 1px solid grey\"></div>\r\n<br/>"
                            },
                            "name": "text - 2"
                        },
                        {
                            "type": 9,
                            "content": {
                                "version": "KqlParameterItem/1.0",
                                "parameters": [
                                    {
                                        "id": "c1c54653-9a7d-41c2-b7c6-0d6f4afbb1c8",
                                        "jsonData": "[string(json('[{\"label\":\"Max\",\"value\":\"Max\"},{\"label\":\"Average\",\"value\":\"Average\",\"selected\":true},{\"label\":\"Min\",\"value\":\"Min\"}]'))]",
                                        "label": "CPU Aggregation",
                                        "name": "cpuAggregation",
                                        "timeContext": {
                                            "durationMs": 86400000
                                        },
                                        "type": 10,
                                        "typeSettings": {
                                            "additionalResourceOptions": []
                                        },
                                        "version": "KqlParameterItem/1.0"
                                    }
                                ],
                                "style": "pills",
                                "queryType": 0,
                                "resourceType": "microsoft.operationalinsights/workspaces"
                            },
                            "name": "parameters - 3"
                        },
                        {
                            "type": 3,
                            "content": {
                                "version": "KqlItem/1.0",
                                "query": "let endDateTime = {timeRange:end};\nlet startDateTime = {timeRange:start};\nlet trendBinSize = {timeRange:grain};\nlet capacityCounterName = 'cpuLimitNanoCores';\nlet usageCounterName = 'cpuUsageNanoCores';\nlet maxOn = indexof(\"{cpuAggregation}\", 'Max');\nlet avgOn = indexof(\"{cpuAggregation}\", 'Avg');\nlet minOn = indexof(\"{cpuAggregation}\", 'Min');\nKubePodInventory\n| where TimeGenerated < endDateTime\n| where TimeGenerated >= startDateTime\n{clusterNameWhereClause}\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\n         ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),\n         PodName = Name\n| distinct Computer, InstanceName, ContainerName, PodName\n| join hint.strategy=shuffle (\n    Perf\n    | where TimeGenerated < endDateTime\n    | where TimeGenerated >= startDateTime\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)\n    | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue, limitA=100\n) on Computer, InstanceName\n| join kind=inner hint.strategy=shuffle (\n    Perf\n    | where TimeGenerated < endDateTime + trendBinSize\n    | where TimeGenerated >= startDateTime - trendBinSize\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, limit=100, TimeGenerated\n) on Computer, InstanceName\n| where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime\n| project  ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue,Computer\n| summarize AggregatedValue= iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize),Computer\n",
                                "size": 3,
                                "aggregation": 3,
                                "showAnalytics": true,
                                "title": "CPU Usage by Node",
                                "timeContext": {
                                    "durationMs": 86400000
                                },
                                "queryType": 0,
                                "resourceType": "microsoft.operationalinsights/workspaces",
                                "visualization": "timechart",
                                "chartSettings": {
                                    "showLegend": true,
                                    "showMetrics": false,
                                    "ySettings": {
                                        "max": 100,
                                        "min": 0
                                    }
                                }
                            },
                            "showPin": true,
                            "name": "query - 4"
                        },
                        {
                            "type": 9,
                            "content": {
                                "version": "KqlParameterItem/1.0",
                                "parameters": [
                                    {
                                        "id": "d66aef8f-45a6-4541-ab98-e6608d85af96",
                                        "version": "KqlParameterItem/1.0",
                                        "name": "memoryAggregation",
                                        "label": "Memory Aggregation",
                                        "type": 10,
                                        "typeSettings": {
                                            "additionalResourceOptions": []
                                        },
                                        "jsonData": "[string(json('[{\"label\":\"Max\",\"value\":\"Max\"},{\"label\":\"Average\",\"value\":\"Average\",\"selected\":true},{\"label\":\"Min\",\"value\":\"Min\"}]'))]",
                                        "timeContext": {
                                            "durationMs": 86400000
                                        }
                                    }
                                ],
                                "style": "pills",
                                "queryType": 0,
                                "resourceType": "microsoft.operationalinsights/workspaces"
                            },
                            "name": "parameters - 5"
                        },
                        {
                            "type": 3,
                            "content": {
                                "version": "KqlItem/1.0",
                                "query": "let endDateTime = {timeRange:end};\nlet startDateTime = {timeRange:start};\nlet trendBinSize = {timeRange:grain};\nlet capacityCounterName = 'memoryLimitBytes';\nlet usageCounterName = 'memoryRssBytes';\nlet maxOn = indexof(\"{memoryAggregation}\", 'Max');\nlet avgOn = indexof(\"{memoryAggregation}\", 'Avg');\nlet minOn = indexof(\"{memoryAggregation}\", 'Min');\nKubePodInventory\n| where TimeGenerated < endDateTime\n| where TimeGenerated >= startDateTime\n{clusterNameWhereClause}\n| extend InstanceName = strcat(ClusterId, '/', ContainerName),\n         ContainerName = strcat(ControllerName, '/', tostring(split(ContainerName, '/')[1])),\n         PodName=Name\n| distinct Computer, InstanceName, ContainerName\n| join hint.strategy=shuffle (\n    Perf\n    | where TimeGenerated < endDateTime\n    | where TimeGenerated >= startDateTime\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == capacityCounterName\n    | summarize LimitValue = max(CounterValue) by Computer, InstanceName, bin(TimeGenerated, trendBinSize)\n    | project Computer, InstanceName, LimitStartTime = TimeGenerated, LimitEndTime = TimeGenerated + trendBinSize, LimitValue\n) on Computer, InstanceName\n| join kind=inner hint.strategy=shuffle (\n    Perf\n    | where TimeGenerated < endDateTime + trendBinSize\n    | where TimeGenerated >= startDateTime - trendBinSize\n    | where ObjectName == 'K8SContainer'\n    | where CounterName == usageCounterName\n    | project Computer, InstanceName, UsageValue = CounterValue, TimeGenerated\n) on Computer, InstanceName\n| where TimeGenerated >= LimitStartTime and TimeGenerated < LimitEndTime\n| project Computer, ContainerName, TimeGenerated, UsagePercent = UsageValue * 100.0 / LimitValue\n| summarize AggregatedValue = iif(avgOn != -1, avg(UsagePercent), iif(maxOn != -1, max(UsagePercent), min(UsagePercent))) by bin(TimeGenerated, trendBinSize) , Computer\n",
                                "size": 3,
                                "aggregation": 3,
                                "showAnalytics": true,
                                "title": "Memory Usage by Node",
                                "timeContext": {
                                    "durationMs": 86400000
                                },
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
                            "name": "query - 6"
                        },
                        {
                            "type": 3,
                            "content": {
                                "version": "KqlItem/1.0",
                                "query": "KubeNodeInventory\r\n{clusterNameWhereClause}\r\n| summarize arg_max(TimeGenerated, *) by Computer\r\n| summarize count() by Status\r\n| render piechart\r\n",
                                "size": 0,
                                "showAnalytics": true,
                                "title": "Node Availability ",
                                "queryType": 0,
                                "resourceType": "microsoft.operationalinsights/workspaces",
                                "visualization": "piechart",
                                "tileSettings": {
                                    "showBorder": false
                                }
                            },
                            "showPin": true,
                            "name": "query - 0"
                        }
                    ],
                    "fallbackResourceIds": [
                        "${each.value["workbookSourceId"]}"
                    ],
                    "fromTemplateId": "ArmTemplates-/subscriptions/c7a405fc-3d07-4fac-b4ab-8254c690fad1/resourceGroups/Az-Monitor-La-Ws/providers/microsoft.insights/workbooktemplates/aksnodewb202007272",
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

output "aks_node_workbooks_ids" {
    value = [for x in azurerm_template_deployment.aksnodewb : x.id]
}