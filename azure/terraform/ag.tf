

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  virtual_network_name = azurerm_virtual_network.aksVirtualNetwork.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  virtual_network_name = azurerm_virtual_network.aksVirtualNetwork.name
  address_prefixes     = ["10.0.4.0/24"]
}

resource "azurerm_public_ip" "agpublic" {
  name                = "agpublic-pip"
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.aksVirtualNetwork.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.aksVirtualNetwork.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.aksVirtualNetwork.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.aksVirtualNetwork.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.aksVirtualNetwork.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.aksVirtualNetwork.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.aksVirtualNetwork.name}-rdrcfg"
}

resource "azurerm_application_gateway" "gateway" {
  name                = "appgateway"
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location

   sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "gateway_ip_configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agpublic.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    priority                   = 1
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}