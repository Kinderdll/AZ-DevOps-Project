output "kube_config" {
    value=azurerm_kubernetes_cluster.myAKSCluster.kube_config_raw 
    sensitive = true
}
