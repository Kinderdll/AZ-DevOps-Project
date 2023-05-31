variable "service_principal_id" {
}

variable "service_principal_key" {
}

variable "tenant_id" {
}
variable "subscription_id" {
  
}
variable "location" {
  default = "West Europe"
}
variable "kubernetes_version" {
  default = "1.24"
}

variable "ssh_key"{}

variable "frontend_port_name" {
    default = "myFrontendPort"
}
variable "frontend_ip_configuration_name" {
    default = "myAGIPConfig"
}

variable "backend_address_pool_name" {
    default = "myBackendPool"
}
variable "http_setting_name" {
    default = "myHTTPsetting"
}

variable "listener_name" {
    default = "myListener"
}

variable "request_routing_rule_name" {
    default = "myRoutingRule"
}






