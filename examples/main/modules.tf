module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

module "lb" {
  source  = "claranet/lb/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  allocate_public_ip = true
  enable_nat         = true
}

module "diagnostic_settings" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "x.x.x"

  resource_id = module.lb.lb_id

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]
  log_analytics_destination_type = "Dedicated"
}
