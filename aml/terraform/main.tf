resource "azurerm_resource_group" "aml" {
  name     = "rg-${var.azure_suffix}"
  location = local.location
}
