output "kube_config" {
    value=azurerm_kubernetes_cluster.myAKSCluster.kube_config_raw 
    sensitive = true
}

output "appligation_gateway_id" {
  value =azurerm_application_gateway.myAG.id
}