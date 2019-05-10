# Diagnostic Settings

Create diagnostic settings for Azure resources.

## Example Usage

```hcl
module "diagnostic_settings" {
  source = "innovationnorway/diagnostic-settings/azurerm"

  resource_id = azurerm_key_vault.example.id

  retention_days = 30

  storage_account_id = azurerm_storage_account.main.id
}
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `resource_id` | `string` | The ID of the resource. |
| `log_categories` | `list` | List of log categories. |
| `metric_categories` | `list` | List of metric categories. |
| `retention_days` | `number` | The number of days to keep diagnostic logs. |
| `storage_account_id` | `string` | The ID of the storage account to send diagnostic logs to. |
| `log_analytics_workspace_id` | `string` | The ID of the Log Analytics workspace to send diagnostic logs to. | 
| `eventhub_authorization_rule_id` | `string` | The ID of the Event Hub authorization rule to send diagnostic logs to. |
