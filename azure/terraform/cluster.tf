#Represent CLUSTER module
resource "azurerm_resource_group" "myResourceGroup" {
    name= "myResourceGroup"
    location = var.location
}

resource "azurerm_kubernetes_cluster" "myAKSCluster" {
  name = "myAKSCluster"
  location = azurerm_resource_group.myResourceGroup.location
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  dns_prefix = "myAKSCuster"
  kubernetes_version = var.kubernetes_version

  #PROVIDE DEFAULT NODE POOL
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    type = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id = var.service_principal_id
    client_secret = var.service_principal_key
  }
  #IN case we need to access node
  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "basic"
  }


}

