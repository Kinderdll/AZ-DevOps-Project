#Represent CLUSTER module
resource "azurerm_resource_group" "myResourceGroup" {
    name= "myResourceGroup"
    location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "aksVirtualNetwork" {
  name                = "aksVirtualNetwork"
  address_space       = ["10.0.0.0/16"] 
  location            = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
}

# Create a subnet
resource "azurerm_subnet" "aksSubnet" {
  name                 = "aksSubnet"
  resource_group_name  = azurerm_resource_group.myResourceGroup.name
  virtual_network_name = azurerm_virtual_network.aksVirtualNetwork.name
  address_prefixes     = ["10.0.1.0/24"]  


  #Delegation is only Needed when you need your AKS to connect to ACI
  # delegation {
  #   name = "aksDelegation"
  #   service_delegation {
  #     name    = "Microsoft.ContainerInstance/containerGroups"
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  #   }
  # }
}


# Create the AKS cluster
resource "azurerm_kubernetes_cluster" "myAKSCluster" {
  name                  = "myAKSCluster"
  location              = azurerm_resource_group.myResourceGroup.location
  resource_group_name   = azurerm_resource_group.myResourceGroup.name
  dns_prefix            = "myAKSCuster"
  kubernetes_version    = var.kubernetes_version

  default_node_pool {
    name                = "aksnode"
    node_count          = 1 
    vm_size             = "Standard_DS2_v2" 
    type                = "VirtualMachineScaleSets"
    os_disk_size_gb     = 30
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.0.1.10"  # Update with an IP address within the subnet's range
    service_cidr       = "10.0.1.0/24"  # Update with the subnet CIDR
    network_policy     = "azure"  # Optional: Update with your desired network policy plugin
  }

  #SystemAssigned or ServicePrincipal option
  identity {
    type = "SystemAssigned" 
  }

  # service_principal {
  #   client_id     = var.service_principal_id
  #   client_secret = var.service_principal_key
  # }



   ingress_application_gateway {
      gateway_name = "aks-cluster-ingress"
      subnet_cidr = "10.225.0.0/16"
    }
  
  #IN case we need to access node
  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_key
    }
  }
  tags = {
    environment = "myAKS" 
  }
}






