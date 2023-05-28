resource "azurerm_network_watcher" "network_watcher" {
  name                = "network_watcher_westeurope"
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
}