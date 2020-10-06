# Azure Diagnostic Settings
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/diagnostic-settings/azurerm/)

This module is based on work from [Innovation Norway](https://github.com/InnovationNorway/).

This Terraform enables the Diagnostic Settings on a given Azure resource.

## Version compatibility

| Module version    | Terraform version | AzureRM version |
|-------------------|-------------------|-----------------|
| >= 3.x.x          | 0.12.x            | >= 2.0          |
| >= 2.x.x, < 3.x.x | 0.12.x            | <  2.0          |
| <  2.x.x          | 0.11.x            | <  2.0          |

## Usage

You can use this module by including it this way:
```hcl
data "azurerm_resources" "resources" {
  ...
}

module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

resource "azurerm_storage_account" "logs" {
  ...
}

resource "azurerm_log_analytics_workspace" "logs" {
  ...
}

resource "azurerm_eventhub_namespace" "logs" {
  ...
}

resource "azurerm_eventhub" "logs" {
  ...
}

resource "azurerm_eventhub_authorization_rule" "logs" {
  ...
}

module "diagnostic-settings" {
  for_each = data.azurerm_resources.resources

  source  = "claranet/diagnostic-settings/azurerm"
  version = "x.x.x"

  resource_id = each.id

  logs_destinations_ids = [
    azurerm_storage_account.logs.id,
    azurerm_log_analytics_workspace.example.id,
    azurerm_eventhub_authorization_rule.logs.id,
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eventhub\_name | Event Hub name if one of the destinations is an Event Hub. | `string` | `null` | no |
| log\_categories | List of log categories. | `list(string)` | `null` | no |
| logs\_destinations\_ids | n/a | `list(string)` | <pre>[<br>  "/subscriptions/197703a3-363b-446a-ab2d-c3b7542bb84d/resourceGroups/app-loccitane-xcms-dev-rg/providers/Microsoft.Storage/storageAccounts/filesxcmsloccdevst",<br>  "/subscriptions/197703a3-363b-446a-ab2d-c3b7542bb84d/resourcegroups/run-loccitane-xcms-dev-rg/providers/microsoft.operationalinsights/workspaces/logs-run-loccitane-xcms-euw-dev-log"<br>]</pre> | no |
| metric\_categories | List of metric categories. | `list(string)` | `null` | no |
| name | The name of the diagnostic setting. | `string` | `"default"` | no |
| resource\_id | The ID of the resource. | `string` | n/a | yes |
| retention\_days | The number of days to keep diagnostic logs. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| diagnostic\_settings\_id | ID of the Diagnostic Settings. |

## Related documentation

Terraform documentation: [terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
