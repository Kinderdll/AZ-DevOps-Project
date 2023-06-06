variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "aks_service_principal_app_id" {
  description = "Application ID/Client ID  of the service principal. Used by AKS to manage AKS related resources on Azure like vms, subnets."
}

variable "aks_service_principal_client_secret" {
  description = "Secret of the service principal. Used by AKS to manage Azure."
}

variable "aks_service_principal_object_id" {
  description = "Object ID of the service principal."
}

variable "virtual_network_name" {
  description = "Virtual network name"
  default     = "aksVirtualNetwork"
}

variable "virtual_network_address_prefix" {
  description = "VNET address prefix"
  default     = "192.168.0.0/16"
}

variable "aks_subnet_name" {
  description = "Subnet Name"
  default     = "k8subnet"
}

variable "apg_subnet_name" {
 description = "Subnet Name" 
 default = "appgwsubnet"
}
variable "aks_subnet_address_prefix" {
  description = "Subnet address prefix."
  default     = "192.168.0.0/24"
}

variable "app_gateway_subnet_address_prefix" {
  description = "Subnet server IP address."
  default     = "192.168.1.0/24"
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway"
  default     = "ApplicationGateway"
}

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU"
  default     = "Standard_v2"
}

variable "app_gateway_tier" {
  description = "Tier of the Application Gateway tier"
  default     = "Standard_v2"
}

variable "aks_name" {
  description = "AKS cluster name"
  default     = "myAKSCluster"
}
variable "aks_dns_prefix" {
  description = "Optional DNS prefix to use with hosted Kubernetes API server FQDN."
  default     = "myAKSCuster"
}

variable "aks_agent_os_disk_size" {
  description = "Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 applies the default disk size for that agentVMSize."
  default     = 30
}

variable "aks_agent_count" {
  description = "The number of agent nodes for the cluster."
  default     = 1
}

variable "aks_agent_vm_size" {
  description = "VM size"
  default     = "Standard_DS2_v2"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.24"
}

variable "aks_service_cidr" {
  description = "CIDR notation IP range from which to assign service cluster IPs"
  default     = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS server IP address"
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}


variable "vm_user_name" {
  description = "User name for the VM"
  default     = "azureuser"
}

variable "ssh_key" {
  description = "Public key path for SSH."
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
  }
}

variable "subscription_id" {
  description="Secret for Subscription."
}
variable "tenant_id" {
  description = "Secret for TenantId"
  
}