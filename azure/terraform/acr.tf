resource "azurerm_container_registry" "kinderdllacr" {
  name                     = "kinderdllacr"
  resource_group_name      = azurerm_resource_group.myResourceGroup.name
  location                 = azurerm_resource_group.myResourceGroup.location
  sku                      = "Basic"
  admin_enabled            = true
}
