resource "azurerm_resource_group" "rg" {
  name     = "aks_terraform_rg"
  location = "canadacentral"
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}


# Subnet for AKS nodes
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}



resource "azurerm_container_registry" "acr" {
  name                = "myacr032023"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true

   depends_on = [
    azurerm_subnet.aks_subnet,
    azurerm_virtual_network.my_vnet
  ]
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "terraform-aks"
  kubernetes_version  = "1.24.9"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "terraform-aks"

  default_node_pool {
    name                = "system"
    node_count          = 1
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    //availability_zones  = [1, 2, 3]
    //enable_auto_scaling = false
  }
   depends_on = [
    azurerm_subnet.aks_subnet,
    azurerm_virtual_network.my_vnet
  ]
  identity {
    type = "SystemAssigned"
  }

  //network_profile {
  //  load_balancer_sku = "Standard"
  //  network_plugin    = "kubenet" # CNI
  //}
   network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
  }
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}
