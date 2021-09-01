resource "azurerm_dashboard" "vmdash" {
    for_each            = var.vm_dashboards
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
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics \n| where TimeGenerated > ago(24h)\n| where (Namespace == \"Processor\") and (SourceSystem == \"Insights\")\n"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Average"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "49f257f7-26ed-4d8e-b876-e4452c3af735"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "TimeRange",
                    "isOptional": true
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "CPU Utilization",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "1": {
              "position": {
                "x": 7,
                "y": 0,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics \n| where TimeGenerated > ago(24h)\n| where (Namespace == \"Memory\") and (SourceSystem == \"Insights\")\n"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Average"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "11785549-1207-47ff-bd96-f3f9dff12dbe"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "TimeRange",
                    "isOptional": true
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Available Memory",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "2": {
              "position": {
                "x": 14,
                "y": 0,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics\n| where Namespace == \"LogicalDisk\"\n| where (Name == \"ReadsPerSecond\") and (Namespace == \"LogicalDisk\")\n"
                  },
                  {
                    "name": "TimeRange",
                    "value": "PT1H"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Sum"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "1c77f52a-a8f5-4bc5-86c9-91cd114437d7"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Disk Reads/Sec",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "3": {
              "position": {
                "x": 0,
                "y": 4,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics \n| where TimeGenerated > ago(24h)\n| where (Namespace == \"LogicalDisk\") and (SourceSystem == \"Insights\")\n| where Name == \"FreeSpacePercentage\"\n"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Sum"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "15c7268b-10ec-4405-8284-63d9a71430f0"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "TimeRange",
                    "isOptional": true
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Free Space (MB)",
                    "PartSubTitle": "Windows & Linux",
                    "Query": "InsightsMetrics \n| where TimeGenerated > ago(24h)\n| where (Namespace == \"LogicalDisk\") and (SourceSystem == \"Insights\")\n| where Name == \"FreeSpaceMB\"\n"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "4": {
              "position": {
                "x": 7,
                "y": 4,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics\n| where Name == \"TransfersPerSecond\"\n| where Namespace == \"LogicalDisk\"\n"
                  },
                  {
                    "name": "TimeRange",
                    "value": "P1D"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Sum"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "885355b7-b5c8-471b-9207-132b4897fa26"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Transfers/Sec",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "5": {
              "position": {
                "x": 14,
                "y": 4,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics\n| where Namespace == \"LogicalDisk\"\n| where (Name == \"WritesPerSecond\") and (Namespace == \"LogicalDisk\")\n"
                  },
                  {
                    "name": "TimeRange",
                    "value": "PT1H"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Average"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "43470374-583e-46fe-90e5-fb48541cef7d"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Disk Writes/Sec",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "6": {
              "position": {
                "x": 0,
                "y": 8,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics\n| where Namespace == \"Network\"\n| where Name == \"ReadBytesPerSecond\"\n"
                  },
                  {
                    "name": "TimeRange",
                    "value": "PT1H"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Average"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "9da729a0-1a58-45c0-9a14-7ceca032093c"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Network - Read Bytes/Sec",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "7": {
              "position": {
                "x": 7,
                "y": 8,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "InsightsMetrics\n| where Namespace == \"Network\"\n| where Name == \"WriteBytesPerSecond\"\n"
                  },
                  {
                    "name": "TimeRange",
                    "value": "PT1H"
                  },
                  {
                    "name": "Dimensions",
                    "value": {
                      "xAxis": {
                        "name": "TimeGenerated",
                        "type": "datetime"
                      },
                      "yAxis": [
                        {
                          "name": "Val",
                          "type": "real"
                        }
                      ],
                      "splitBy": [
                        {
                          "name": "Computer",
                          "type": "string"
                        }
                      ],
                      "aggregation": "Sum"
                    }
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "753d3126-296d-48ab-8e4c-8f9bbe76d04c"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsChart"
                  },
                  {
                    "name": "SpecificChart",
                    "value": "Line"
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Network - Write Bytes/Sec",
                    "PartSubTitle": "Windows & Linux"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "8": {
              "position": {
                "x": 14,
                "y": 8,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "ComponentId",
                    "value": {
                      "SubscriptionId": "${var.subscriptionId}",
                      "ResourceGroup": "${each.value["resourceGroupName"]}",
                      "Name": "${each.value["resourceName"]}",
                      "ResourceId": "${each.value["resourceId"]}"
                    }
                  },
                  {
                    "name": "Query",
                    "value": "// Not reporting VMs \n// VMs that have not reported a heartbeat in the last 5 minutes. \nHeartbeat \n| summarize LastCall = max(TimeGenerated) by Computer \n| where LastCall > ago(5m)\n"
                  },
                  {
                    "name": "TimeRange",
                    "value": "P1D"
                  },
                  {
                    "name": "Version",
                    "value": "1.0"
                  },
                  {
                    "name": "PartId",
                    "value": "10b122c6-113d-4705-be94-16c3a251dfdb"
                  },
                  {
                    "name": "PartTitle",
                    "value": "Analytics"
                  },
                  {
                    "name": "PartSubTitle",
                    "value": "${each.value["resourceName"]}"
                  },
                  {
                    "name": "resourceTypeMode",
                    "value": "workspace"
                  },
                  {
                    "name": "ControlType",
                    "value": "AnalyticsGrid"
                  },
                  {
                    "name": "Dimensions",
                    "isOptional": true
                  },
                  {
                    "name": "DashboardId",
                    "isOptional": true
                  },
                  {
                    "name": "SpecificChart",
                    "isOptional": true
                  }
                ],
                "type": "Extension/AppInsightsExtension/PartType/AnalyticsPart",
                "settings": {
                  "content": {
                    "PartTitle": "Unavailable VMs",
                    "PartSubTitle": "Missed Heartbeats",
                    "Query": "// Not reporting VMs \n// VMs that have not reported a heartbeat in the last 5 minutes. \nHeartbeat \n| summarize LastCall = max(TimeGenerated) by Computer \n| where LastCall < ago(5m)\n"
                  }
                },
                "asset": {
                  "idInputName": "ComponentId",
                  "type": "ApplicationInsights"
                }
              }
            },
            "9": {
              "position": {
                "x": 7,
                "y": 12,
                "colSpan": 7,
                "rowSpan": 4
              },
              "metadata": {
                "inputs": [
                  {
                    "name": "options",
                    "value": {
                      "chart": {
                        "metrics": [
                          {
                            "resourceMetadata": {
                              "region": "eastus2",
                              "resourceType": "microsoft.compute/virtualmachines",
                              "subscription": {
                                "subscriptionId": "${var.subscriptionId}",
                                "displayName": "02537",
                                "uniqueDisplayName": "02537"
                              }
                            },
                            "name": "OS Disk Queue Depth",
                            "aggregationType": 4,
                            "namespace": "microsoft.compute/virtualmachines",
                            "metricVisualization": {
                              "displayName": "OS Disk Queue Depth (Preview)",
                              "resourceDisplayName": "02537"
                            }
                          }
                        ],
                        "title": "Avg OS Disk Queue Depth (Preview) for 02537 in East US 2 region  by ResourceId where ResourceGroupName = 'poc-ATT'",
                        "titleKind": 1,
                        "visualization": {
                          "chartType": 2,
                          "legendVisualization": {
                            "isVisible": true,
                            "position": 2,
                            "hideSubtitle": false
                          },
                          "axisVisualization": {
                            "x": {
                              "isVisible": true,
                              "axisType": 2
                            },
                            "y": {
                              "isVisible": true,
                              "axisType": 1
                            }
                          }
                        },
                        "filterCollection": {
                          "filters": [
                            {
                              "key": "Microsoft.ResourceGroupName",
                              "operator": 0,
                              "values": [
                                "${each.value["resourceGroupName"]}"
                              ]
                            }
                          ]
                        },
                        "grouping": {
                          "dimension": "Microsoft.ResourceId"
                        }
                      },
                      "version": 2
                    }
                  },
                  {
                    "name": "sharedTimeRange",
                    "isOptional": true
                  }
                ],
                "type": "Extension/HubsExtension/PartType/MonitorChartPart",
                "settings": {
                  "content": {
                    "options": {
                      "chart": {
                        "metrics": [
                          {
                            "resourceMetadata": {
                              "region": "eastus2",
                              "resourceType": "microsoft.compute/virtualmachines",
                              "subscription": {
                                "subscriptionId": "${var.subscriptionId}",
                                "displayName": "02537",
                                "uniqueDisplayName": "02537"
                              }
                            },
                            "name": "OS Disk Queue Depth",
                            "aggregationType": 4,
                            "namespace": "microsoft.compute/virtualmachines",
                            "metricVisualization": {
                              "displayName": "OS Disk Queue Depth (Preview)",
                              "resourceDisplayName": "02537"
                            }
                          }
                        ],
                        "title": "Avg OS Disk Queue Depth (Preview) for 02537 in East US 2 region  by ResourceId where ResourceGroupName = '${each.value["resourceGroupName"]}'",
                        "titleKind": 1,
                        "visualization": {
                          "chartType": 2,
                          "legendVisualization": {
                            "isVisible": true,
                            "position": 2,
                            "hideSubtitle": false
                          },
                          "axisVisualization": {
                            "x": {
                              "isVisible": true,
                              "axisType": 2
                            },
                            "y": {
                              "isVisible": true,
                              "axisType": 1
                            }
                          },
                          "disablePinning": true
                        },
                        "grouping": {
                          "dimension": "Microsoft.ResourceId"
                        }
                      },
                      "version": 2
                    }
                  }
                },
                "filters": {
                  "Microsoft.ResourceGroupName": {
                    "model": {
                      "operator": "equals",
                      "values": [
                        "${each.value["resourceGroupName"]}"
                      ]
                    }
                  }
                }
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
                  "relative": "1h"
                },
                "displayCache": {
                  "name": "UTC Time",
                  "value": "Past hour"
                },
                "filteredPartIds": [
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e554008",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e55400a",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e55400c",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e55400e",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e554010",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e554012",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e554014",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e554016",
                  "StartboardPart-AnalyticsPart-dec8b737-3cd0-42ec-ae23-7e3c2e554018",
                  "StartboardPart-MonitorChartPart-dec8b737-3cd0-42ec-ae23-7e3c2e55401a"
                ]
              }
            }
          }
        }
      }
    }
    DASH
}