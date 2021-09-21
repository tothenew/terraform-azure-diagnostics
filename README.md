# Azure Diagnostic Settings
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/diagnostic-settings/azurerm/)

This module is based on work from [Innovation Norway](https://github.com/InnovationNorway/).

This Terraform enables the Diagnostic Settings on a given Azure resource.

<!-- BEGIN_TF_DOCS -->
## Global versionning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
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

```

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 1.31 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_categories.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| log\_analytics\_destination\_type | When set to 'Dedicated' logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. Azure Data Factory is the only compatible resource so far. | `string` | `"AzureDiagnostics"` | no |
| log\_categories | List of log categories. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. | `list(string)` | n/a | yes |
| metric\_categories | List of metric categories. | `list(string)` | `null` | no |
| name | The name of the diagnostic setting. | `string` | `"default"` | no |
| resource\_id | The ID of the resource on which activate the diagnostic settings. | `string` | n/a | yes |
| retention\_days | The number of days to keep diagnostic logs. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| diagnostic\_settings\_id | ID of the Diagnostic Settings. |
<!-- END_TF_DOCS -->
## Related documentation

Azure Diagnostic settings documentation: [docs.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings](https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings)
