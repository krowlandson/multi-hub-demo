# Hub virtual network for non-production Azure Route Server sidecar

resource "azurerm_virtual_network" "hub_nonprod_ars" {
  name                = "ars-h-vnet001"
  resource_group_name = azurerm_resource_group.hub_nonprod_ars.name
  address_space       = ["10.100.0.0/24"]
  location            = var.location
}

resource "azurerm_subnet" "hub_nonprod_ars_route_server" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hub_nonprod_ars.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod_ars.name
  address_prefixes     = ["10.100.0.128/26"]
}

resource "azurerm_subnet" "hub_nonprod_ars_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.hub_nonprod_ars.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod_ars.name
  address_prefixes     = ["10.100.0.0/26"]
}

# The following is not possible due to platform restrictions on the RouteServerSubnet

# resource "azurerm_route_table" "hub_nonprod_ars_route_server" {
#   name                          = "r-h-udr"
#   resource_group_name           = azurerm_resource_group.hub_nonprod_ars.name
#   location                      = var.location
#   disable_bgp_route_propagation = false

#   route {
#       name                   = "fictionalOnPremRoute1"
#       address_prefix         = "11.0.0.0/16"
#       next_hop_type          = "VirtualAppliance"
#       next_hop_in_ip_address = element(azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.bgp_settings[*].peering_addresses[0].default_addresses[0], 0)
#   }

# }

# resource "azurerm_subnet_route_table_association" "hub_nonprod_ars_route_server" {
#   subnet_id      = azurerm_subnet.hub_nonprod_ars_route_server.id
#   route_table_id = azurerm_route_table.hub_nonprod_ars_route_server.id
# }

# Hub virtual network for non-production zone

resource "azurerm_virtual_network" "hub_nonprod" {
  name                = "n-h-vnet001"
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  address_space       = ["10.47.0.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "hub_nonprod_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_nonprod.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod.name
  address_prefixes     = ["10.47.0.0/26"]
}

resource "azurerm_subnet" "hub_nonprod_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub_nonprod.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod.name
  address_prefixes     = ["10.47.0.64/26"]
}

resource "azurerm_subnet" "hub_nonprod_route_server" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hub_nonprod.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod.name
  address_prefixes     = ["10.47.0.128/26"]
}

resource "azurerm_subnet" "hub_nonprod_nva" {
  name                 = "NvaSubnet"
  resource_group_name  = azurerm_resource_group.hub_nonprod.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod.name
  address_prefixes     = ["10.47.0.192/26"]
}

resource "azurerm_subnet" "hub_nonprod_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.hub_nonprod.name
  virtual_network_name = azurerm_virtual_network.hub_nonprod.name
  address_prefixes     = ["10.47.2.0/24"]
}

# Hub virtual network for Internet zone

resource "azurerm_virtual_network" "hub_internet" {
  name                = "i-h-vnet001"
  resource_group_name = azurerm_resource_group.hub_internet.name
  address_space       = ["10.47.4.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "hub_internet_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_internet.name
  virtual_network_name = azurerm_virtual_network.hub_internet.name
  address_prefixes     = ["10.47.4.0/26"]
}

resource "azurerm_subnet" "hub_internet_route_server" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hub_internet.name
  virtual_network_name = azurerm_virtual_network.hub_internet.name
  address_prefixes     = ["10.47.4.128/26"]
}

resource "azurerm_subnet" "hub_internet_nva" {
  name                 = "NvaSubnet"
  resource_group_name  = azurerm_resource_group.hub_internet.name
  virtual_network_name = azurerm_virtual_network.hub_internet.name
  address_prefixes     = ["10.47.4.192/26"]
}

resource "azurerm_subnet" "hub_internet_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.hub_internet.name
  virtual_network_name = azurerm_virtual_network.hub_internet.name
  address_prefixes     = ["10.47.6.0/24"]
}

# Hub virtual network for management zone

resource "azurerm_virtual_network" "hub_management" {
  name                = "m-h-vnet001"
  resource_group_name = azurerm_resource_group.hub_management.name
  address_space       = ["10.47.8.0/22"]
  location            = var.location
}

resource "azurerm_subnet" "hub_management_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_management.name
  virtual_network_name = azurerm_virtual_network.hub_management.name
  address_prefixes     = ["10.47.8.0/26"]
}

resource "azurerm_subnet" "hub_management_route_server" {
  name                 = "RouteServerSubnet"
  resource_group_name  = azurerm_resource_group.hub_management.name
  virtual_network_name = azurerm_virtual_network.hub_management.name
  address_prefixes     = ["10.47.8.128/26"]
}

resource "azurerm_subnet" "hub_management_nva" {
  name                 = "NvaSubnet"
  resource_group_name  = azurerm_resource_group.hub_management.name
  virtual_network_name = azurerm_virtual_network.hub_management.name
  address_prefixes     = ["10.47.8.192/26"]
}

resource "azurerm_subnet" "hub_management_default" {
  name                 = "Default"
  resource_group_name  = azurerm_resource_group.hub_management.name
  virtual_network_name = azurerm_virtual_network.hub_management.name
  address_prefixes     = ["10.47.10.0/24"]
}
