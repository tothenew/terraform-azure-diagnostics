module "logs" {
  source  = "git::https://github.com/tothenew/terraform-azure-loganalytics.git"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "eventhub" {
  source  = "git::https://github.com/tothenew/terraform-azure-eventhub.git"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  create_dedicated_cluster = false

  namespace_parameters = {
    sku      = "Standard"
    capacity = 2
  }

  hubs_parameters = {
    logs = {
      custom_name     = "main-logs-hub"
      partition_count = 2
    }
  }

  logs_destinations_ids = []
}

module "diagnostic_settings" {
  source  = "git::https://github.com/tothenew/terraform-azure-diagnostics.git"

  resource_id = module.lb.lb_id

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
    format("%s|%s", module.eventhub.namespace_send_authorization_rule.id, module.eventhub.eventhubs["logs"].name),
  ]

  log_analytics_destination_type = "Dedicated"
}
