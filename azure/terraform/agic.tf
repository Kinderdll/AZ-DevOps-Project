
resource "azurerm_virtual_network" "myAGICVN" {
  name                = "myAGICVN"
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  virtual_network_name = azurerm_virtual_network.myAGICVN.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  virtual_network_name = azurerm_virtual_network.myAGICVN.name
  address_prefixes     = ["10.254.2.0/24"]
}


# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.myAGICVN.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.myAGICVN.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.myAGICVN.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.myAGICVN.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.myAGICVN.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.myAGICVN.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.myAGICVN.name}-rdrcfg"
}

resource "azurerm_public_ip" "myPublicIP" {
  name                = "my-public-ip"
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  allocation_method   = "Dynamic"
}

resource "azurerm_application_gateway" "myAG" {
  name                = "myAG"
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location

    sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
    
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    #subnet_id = "${azurerm_subnet.frontend.id}"
    public_ip_address_id = azurerm_public_ip.myPublicIP.id
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
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}