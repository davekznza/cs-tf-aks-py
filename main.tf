# Generate a random ID for unique resource names
resource "random_pet" "rg_name" {
  prefix = "aks"
}

# create resource group
resource "azurerm_resource_group" "rg" {
  name     = "${random_pet.rg_name.id}-rg"
  location = "eastus"
}

# create AKS cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${random_pet.rg_name.id}-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${random_pet.rg_name.id}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}

# output kubeconfig for accessing the cluster
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "kubernetes_cluster_name" {
  value     = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  value     = azurerm_resource_group.rg.name
}
