# Resource Group
resource "azurerm_resource_group" "rg_01" {
  name     = "rg-cicd-terraform-app-araujobmw" # Reemplazar apellido
  location = "East US"
}

# AKS
resource "azurerm_kubernetes_cluster" "aks_01" {
  name                = "aks-dev-eastus"
  location            = azurerm_resource_group.rg_01.location
  resource_group_name = azurerm_resource_group.rg_01.name
  dns_prefix          = "aksdev"

  # Control plane GRATIS
  sku_tier = "Free"

  # Nodo económico
  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B2s"
    os_sku              = "AzureLinux"
    type                = "VirtualMachineScaleSets"
    
    auto_scaling_enabled = true
    min_count           = 1
    max_count           = 3
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

}

resource "azurerm_container_registry" "global_acr" {
  name                = "acrglobalcicd"
  resource_group_name = azurerm_resource_group.rg_01.name
  location            = azurerm_resource_group.rg_01.location
  sku                 = "Basic"
  admin_enabled       = false
}

## Este bloque estará comentado en el primer plan/apply para evitar errores de dependencia.
## Luego de crear el AKS, descomentar y aplicar de nuevo para asignar el rol AcrPull al AKS.

# resource "azurerm_role_assignment" "global_acr_pull_image" {
#   principal_id                     = azurerm_kubernetes_cluster.aks_01.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.global_acr.id
#   skip_service_principal_aad_check = true
# }