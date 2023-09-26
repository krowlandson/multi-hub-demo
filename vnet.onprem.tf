# On-premise virtual network for non-production zone

resource "azurerm_virtual_network" "onprem_dc1_nonprod" {
  name                = "n-dc-vnet001"
  resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
}

resource "azurerm_subnet" "onprem_dc1_nonprod_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem_dc1_nonprod.name
  virtual_network_name = azurerm_virtual_network.onprem_dc1_nonprod.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "onprem_dc1_nonprod_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.onprem_dc1_nonprod.name
  virtual_network_name = azurerm_virtual_network.onprem_dc1_nonprod.name
  address_prefixes     = ["10.0.1.0/24"]
}

# On-premise virtual network for management zone

resource "azurerm_virtual_network" "onprem_dc1_management" {
  name                = "m-dc-vnet001"
  resource_group_name = azurerm_resource_group.onprem_dc1_management.name
  address_space       = ["10.49.0.0/16", "10.50.0.0/16"]
  location            = var.location
}

resource "azurerm_subnet" "onprem_dc1_management_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem_dc1_management.name
  virtual_network_name = azurerm_virtual_network.onprem_dc1_management.name
  address_prefixes     = ["10.49.0.0/24"]
}

resource "azurerm_subnet" "onprem_dc1_management_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.onprem_dc1_management.name
  virtual_network_name = azurerm_virtual_network.onprem_dc1_management.name
  address_prefixes     = ["10.49.1.0/24"]
}
