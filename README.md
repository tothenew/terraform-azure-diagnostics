# Azure Diagnostic Settings
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/diagnostic-settings/azurerm/)

This module is based on work from [Innovation Norway](https://github.com/InnovationNorway/).

This Terraform enables the Diagnostic Settings on a given Azure resource.

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 5.x.x       | 0.15.x & 1.0.x    | >= 2.0          |
| >= 4.x.x       | 0.13.x            | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

You can use this module by including it this way:
```hcl
data "azurerm_resources" "resources" {
  ...
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

  resource_id = each.value.id

  logs_destinations_ids = [
    azurerm_storage_account.logs.id,
    azurerm_log_analytics_workspace.example.id,
    azurerm_eventhub_authorization_rule.logs.id,
  ]
  log_analytics_destination_type = "Dedicated"

}
```

<!-- BEGIN_TF_DOCS -->
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

Terraform documentation: [terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html](https://www.terraform.io/docs/providers/azurerm/r/monitor_diagnostic_setting.html)
