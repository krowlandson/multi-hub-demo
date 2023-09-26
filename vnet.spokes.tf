resource "azurerm_virtual_network" "spoke_nonprod_001" {
  name                = "n-s-vnet001"
  resource_group_name = azurerm_resource_group.spoke_nonprod_001.name
  address_space       = ["10.226.0.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "spoke_nonprod_001_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.spoke_nonprod_001.name
  virtual_network_name = azurerm_virtual_network.spoke_nonprod_001.name
  address_prefixes     = ["10.226.0.0/24"]
}

resource "azurerm_virtual_network" "spoke_nonprod_002" {
  name                = "n-s-vnet002"
  resource_group_name = azurerm_resource_group.spoke_nonprod_002.name
  address_space       = ["10.226.4.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "spoke_nonprod_002_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.spoke_nonprod_002.name
  virtual_network_name = azurerm_virtual_network.spoke_nonprod_002.name
  address_prefixes     = ["10.226.4.0/24"]
}

resource "azurerm_virtual_network" "spoke_nonprod_003" {
  name                = "n-s-vnet003"
  resource_group_name = azurerm_resource_group.spoke_nonprod_003.name
  address_space       = ["10.226.8.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "spoke_nonprod_003_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.spoke_nonprod_003.name
  virtual_network_name = azurerm_virtual_network.spoke_nonprod_003.name
  address_prefixes     = ["10.226.8.0/24"]
}

resource "azurerm_virtual_network" "spoke_management" {
  name                = "m-s-vnet001"
  resource_group_name = azurerm_resource_group.spoke_management.name
  address_space       = ["10.12.64.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "spoke_management_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.spoke_management.name
  virtual_network_name = azurerm_virtual_network.spoke_management.name
  address_prefixes     = ["10.12.64.0/24"]
}
