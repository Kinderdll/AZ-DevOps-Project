
resource "azurerm_virtual_network" "nginx-vnet" {
  name                = "nginx-vnet"
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "nginx-subnet" {
  name                 = "nginx-subnet"
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  virtual_network_name = azurerm_virtual_network.nginx-vnet.name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_public_ip" "nginx-public-ip" {
  name                = "nginx-public-ip"
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  allocation_method   = "Static"
  sku = "Standard"
}

