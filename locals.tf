locals {
  log_categories = (
    var.log_categories != null ?
    var.log_categories :
    data.azurerm_monitor_diagnostic_categories.main.logs
  )
  metric_categories = (
    var.metric_categories != null ?
    var.metric_categories :
    data.azurerm_monitor_diagnostic_categories.main.metrics
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

  storage_id       = coalescelist([for r in var.logs_destinations_ids : r if contains(split("/", r), "Microsoft.Storage")], [null])[0]
  log_analytics_id = coalescelist([for r in var.logs_destinations_ids : r if contains(split("/", r), "microsoft.operationalinsights")], [null])[0]
  eventhub_id      = coalescelist([for r in var.logs_destinations_ids : r if contains(split("/", r), "Microsoft.EventHub")], [null])[0]

  // Work only with DataFactory for the moment. To avoid perpetual diff we activate it only on DataFactory
  log_analytics_destination_type = local.log_analytics_id != null && regex("\\/providers\\/([A-Za-z]+\\.[A-Za-z]+)\\/", var.resource_id)[0] == "Microsoft.DataFactory" ? var.log_analytics_destination_type : null
}
