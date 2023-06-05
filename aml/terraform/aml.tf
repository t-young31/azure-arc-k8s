resource "azurerm_application_insights" "aml" {
  name                = "ai-aml-${var.azure_suffix}"
  location            = azurerm_resource_group.aml.location
  resource_group_name = azurerm_resource_group.aml.name
  application_type    = "web"
}

resource "azurerm_key_vault" "aml" {
  name                = "kv${var.azure_suffix}"
  location            = azurerm_resource_group.aml.location
  resource_group_name = azurerm_resource_group.aml.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "aml" {
  name                     = "strgaml${var.azure_suffix}"
  location                 = azurerm_resource_group.aml.location
  resource_group_name      = azurerm_resource_group.aml.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                          = "aml-workspace-${var.azure_suffix}"
  location                      = azurerm_resource_group.aml.location
  resource_group_name           = azurerm_resource_group.aml.name
  application_insights_id       = azurerm_application_insights.aml.id
  key_vault_id                  = azurerm_key_vault.aml.id
  storage_account_id            = azurerm_storage_account.aml.id
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }
}

