output "diagnostic_settings_id" {
  description = "ID of the Diagnostic Settings."
  value       = azurerm_monitor_diagnostic_setting.main.id
}
