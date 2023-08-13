# resource "azurerm_role_assignment" "ra1" {
#   scope                = data.azurerm_subnet.kubesubnet.id
#   role_definition_name = "Network Contributor"
#   principal_id         = var.aks_service_principal_object_id
#   skip_service_principal_aad_check = true
#   depends_on = [azurerm_virtual_network.vnet]
# }

# resource "azurerm_role_assignment" "ra2" {
#   scope                = azurerm_user_assigned_identity.assignedIdentity.id
#   role_definition_name = "Managed Identity Operator"
#   principal_id         = var.aks_service_principal_object_id
#   skip_service_principal_aad_check = true
#   depends_on           = [azurerm_user_assigned_identity.assignedIdentity]
# }

resource "azurerm_role_assignment" "ra3" {
  scope                = azurerm_application_gateway.gateway.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.assignedIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.assignedIdentity, azurerm_application_gateway.gateway]
}

resource "azurerm_role_assignment" "ra4" {
  scope                = azurerm_resource_group.myResourceGroup.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.assignedIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.assignedIdentity, azurerm_application_gateway.gateway]
}