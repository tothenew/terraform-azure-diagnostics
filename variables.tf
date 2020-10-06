variable "name" {
  type        = string
  default     = "default"
  description = "The name of the diagnostic setting."
}

variable "resource_id" {
  type        = string
  description = "The ID of the resource."
}

variable "log_categories" {
  type        = list(string)
  default     = null
  description = "List of log categories."
}

variable "metric_categories" {
  type        = list(string)
  default     = null
  description = "List of metric categories."
}

variable "retention_days" {
  type        = number
  default     = null
  description = "The number of days to keep diagnostic logs."
}

variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set."
}

variable "eventhub_name" {
  description = "Event Hub name if one of the destinations is an Event Hub."
  type        = string
  default     = null
}
