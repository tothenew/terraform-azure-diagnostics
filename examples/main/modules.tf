locals {
  env         = var.environment
  name        = var.client_name
  name_prefix = "${local.env}${local.name}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}rg"
  location = var.location
  tags     = var.extra_tags
}

module "logs" {
  source = "git::https://github.com/tothenew/terraform-azure-loganalytics.git"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = var.location
  location_short      = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

module "eventhub" {
  source = "git::https://github.com/tothenew/terraform-azure-eventhub.git"

  location       = var.location
  location_short = var.location
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = azurerm_resource_group.rg.name

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
  source = "git::https://github.com/tothenew/terraform-azure-diagnostics.git"

  resource_id = var.resource_id

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
    format("%s|%s", module.eventhub.namespace_send_authorization_rule.id, module.eventhub.eventhubs["logs"].name),
  ]

  log_analytics_destination_type = "Dedicated"
}
