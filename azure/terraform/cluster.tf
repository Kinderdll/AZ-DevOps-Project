#Represent CLUSTER module
resource "azurerm_resource_group" "myResourceGroup" {
    name= "myResourceGroup"
    location = var.resource_group_location
}


# Create the AKS cluster
resource "azurerm_kubernetes_cluster" "myAKSCluster" {
  name                  = var.aks_name
  location              = azurerm_resource_group.myResourceGroup.location
  resource_group_name   = azurerm_resource_group.myResourceGroup.name
  dns_prefix = var.aks_dns_prefix
  kubernetes_version    = var.kubernetes_version
  http_application_routing_enabled = false
  default_node_pool {
    name            ="agentpool"
    node_count      = var.aks_agent_count
    vm_size         = var.aks_agent_vm_size
    os_disk_size_gb = var.aks_agent_os_disk_size
    type             = "VirtualMachineScaleSets"
    vnet_subnet_id  = data.azurerm_subnet.kubesubnet.id
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    service_cidr       = var.aks_service_cidr
  }

  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }
    
  #IN case we need to access node
  linux_profile {
    admin_username =var.vm_user_name
    ssh_key {
      key_data = var.ssh_key
    }
  }

  depends_on = [azurerm_virtual_network.vnet, azurerm_application_gateway.gateway]
  tags       = var.tags
}





