# Azure Route Server for non-production Azure Route Server hub

resource "azurerm_public_ip" "hub_nonprod_ars_route_server_pip" {
  name                = "r-h-routerserver-pip"
  location            = azurerm_resource_group.hub_nonprod_ars.location
  resource_group_name = azurerm_resource_group.hub_nonprod_ars.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_route_server" "hub_nonprod_ars" {
  name                             = "r-h-routerserver"
  resource_group_name              = azurerm_resource_group.hub_nonprod_ars.name
  location                         = azurerm_resource_group.hub_nonprod_ars.location
  sku                              = "Standard"
  public_ip_address_id             = azurerm_public_ip.hub_nonprod_ars_route_server_pip.id
  subnet_id                        = azurerm_subnet.hub_nonprod_ars_route_server.id
  branch_to_branch_traffic_enabled = true
}

resource "azurerm_route_server_bgp_connection" "hub_nonprod_ars" {
  for_each = toset([
    "n-h-rras-vm001",
    "i-h-rras-vm001",
    "m-h-rras-vm001",
  ])

  name            = "r-ars-to-${element(split("-", each.value), 0)}-nva-bgpconnection"
  route_server_id = azurerm_route_server.hub_nonprod_ars.id
  peer_asn        = 65000 + element(split(".", module.virtual_machines[each.value].private_ip_address), 2)
  peer_ip         = module.virtual_machines[each.value].private_ip_address

  depends_on = [
    module.virtual_machines,
    azurerm_virtual_network_peering.hub_nonprod_ars_to_spoke,
    azurerm_virtual_network_peering.spoke_to_hub_nonprod_ars,
  ]
}

# # Add BGP connection from non-production ARS to NVAs in management and internet hubs

# resource "azurerm_route_server_bgp_connection" "n_ars_to_m_nva" {
#   name            = "n-ars-to-m-nva-bgpconnection"
#   route_server_id = azurerm_route_server.hub_nonprod.id
#   peer_asn        = 65008
#   peer_ip         = "10.47.8.193"

#   depends_on = [
#     module.virtual_machines
#   ]
# }

# resource "azurerm_route_server_bgp_connection" "n_ars_to_i_nva" {
#   name            = "n-ars-to-i-nva-bgpconnection"
#   route_server_id = azurerm_route_server.hub_nonprod.id
#   peer_asn        = 65004
#   peer_ip         = "10.47.4.193"

#   depends_on = [
#     module.virtual_machines
#   ]
# }

# # Azure Route Server for Internet hub

# # resource "azurerm_public_ip" "hub_internet_route_server_pip" {
# #   name                = "i-h-routerserver-pip"
# #   location            = azurerm_resource_group.hub_internet.location
# #   resource_group_name = azurerm_resource_group.hub_internet.name
# #   allocation_method   = "Static"
# #   sku                 = "Standard"
# # }

# # resource "azurerm_route_server" "hub_internet" {
# #   name                             = "i-h-routerserver"
# #   resource_group_name              = azurerm_resource_group.hub_internet.name
# #   location                         = azurerm_resource_group.hub_internet.location
# #   sku                              = "Standard"
# #   public_ip_address_id             = azurerm_public_ip.hub_internet_route_server_pip.id
# #   subnet_id                        = azurerm_subnet.hub_internet_route_server.id
# #   branch_to_branch_traffic_enabled = true
# # }

# # Azure Route Server for management hub

# resource "azurerm_public_ip" "hub_management_route_server_pip" {
#   name                = "m-h-routerserver-pip"
#   location            = azurerm_resource_group.hub_management.location
#   resource_group_name = azurerm_resource_group.hub_management.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_route_server" "hub_management" {
#   name                             = "m-h-routerserver"
#   resource_group_name              = azurerm_resource_group.hub_management.name
#   location                         = azurerm_resource_group.hub_management.location
#   sku                              = "Standard"
#   public_ip_address_id             = azurerm_public_ip.hub_management_route_server_pip.id
#   subnet_id                        = azurerm_subnet.hub_management_route_server.id
#   branch_to_branch_traffic_enabled = true
# }

# # Add BGP connection from management ARS to NVAs in non-production and internet hubs

# resource "azurerm_route_server_bgp_connection" "m_ars_to_n_nva" {
#   name            = "m-ars-to-n-nva-bgpconnection"
#   route_server_id = azurerm_route_server.hub_management.id
#   peer_asn        = 65000
#   peer_ip         = "10.47.0.193"

#   depends_on = [
#     module.virtual_machines
#   ]
# }

# resource "azurerm_route_server_bgp_connection" "m_ars_to_i_nva" {
#   name            = "m-ars-to-i-nva-bgpconnection"
#   route_server_id = azurerm_route_server.hub_management.id
#   peer_asn        = 65004
#   peer_ip         = "10.47.4.193"

#   depends_on = [
#     module.virtual_machines
#   ]
# }
