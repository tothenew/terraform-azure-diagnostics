locals {
  logs_destinations_ids = var.logs_destinations_ids == null ? [] : var.logs_destinations_ids
  enabled               = length(local.logs_destinations_ids) > 0

  log_categories = (
    var.log_categories != null ?
    var.log_categories :
    try(data.azurerm_monitor_diagnostic_categories.main.0.logs, [])
  )
  metric_categories = (
    var.metric_categories != null ?
    var.metric_categories :
    try(data.azurerm_monitor_diagnostic_categories.main.0.metrics, [])
  )

  logs = {
    for category in local.log_categories : category => {
      enabled        = true
      retention_days = var.retention_days
    }
  }

  metrics = {
    for metric in local.metric_categories : metric => {
      enabled        = true
      retention_days = var.retention_days
    }
  }

  storage_id       = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", r), "Microsoft.Storage")], [null])[0]
  log_analytics_id = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", r), "microsoft.operationalinsights") || contains(split("/", r), "Microsoft.OperationalInsights")], [null])[0]
  eventhub_id      = coalescelist([for r in local.logs_destinations_ids : r if contains(split("/", r), "Microsoft.EventHub")], [null])[0]

  log_analytics_destination_type = local.log_analytics_id != null ? var.log_analytics_destination_type : null
}
