terraform {
  required_version = ">=1.2"
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}


#Install AZ Providers
provider "azurerm" {
#latest version as of current time
  subscription_id = var.subscription_id
  client_id = var.aks_service_principal_app_id
  client_secret=var.aks_service_principal_client_secret
  tenant_id = var.tenant_id

  features {  }
}

# User Assigned Identities 
resource "azurerm_user_assigned_identity" "assignedIdentity" {
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location

  name = "az_identity"

  tags = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name           = var.aks_subnet_name
    address_prefix = var.aks_subnet_address_prefix
  }

  subnet {
    name           = var.apg_subnet_name
    address_prefix = var.app_gateway_subnet_address_prefix
  }

  tags = var.tags
}

data "azurerm_subnet" "kubesubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  depends_on           = [azurerm_virtual_network.vnet]
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = var.apg_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  depends_on           = [azurerm_virtual_network.vnet]
}

