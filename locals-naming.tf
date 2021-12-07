locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  diag_name = coalesce(var.custom_name, var.use_caf_naming ? azurecaf_name.diag.name : "default")
}
