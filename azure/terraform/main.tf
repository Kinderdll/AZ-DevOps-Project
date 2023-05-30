#Install AZ Providers
provider "azurerm" {
#latest version as of current time
  subscription_id = var.subscription_id
  client_id = var.service_principal_id
  client_secret=var.service_principal_key
  tenant_id = var.tenant_id

  features {  }
}