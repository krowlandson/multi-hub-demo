locals {
  route_table_hub_ids = [
    "hub_nonprod",
    "hub_management",
  ]
  spoke_cidr_ranges = [
    "10.226.0.0/22",
    "10.226.4.0/22",
    "10.226.8.0/22",
    "10.12.64.0/22",
  ]
  gateway_address_by_hub_id = {
    hub_internet   = module.virtual_machines["i-h-rras-vm001"].private_ip_address
    hub_nonprod    = module.virtual_machines["n-h-rras-vm001"].private_ip_address
    hub_management = module.virtual_machines["m-h-rras-vm001"].private_ip_address
  }
}

resource "azurerm_route_table" "gateway" {
  for_each = {
    for k, v in local.azurerm_virtual_network_config :
    k => v
    if contains(local.route_table_hub_ids, k)
  }

  name                          = "${each.key}-gateway-routetable"
  location                      = local.azurerm_virtual_network_config[each.key].location
  resource_group_name           = local.azurerm_virtual_network_config[each.key].resource_group_name
  disable_bgp_route_propagation = false

  # Dynamic configuration blocks
  dynamic "route" {
    for_each = toset(concat(each.value.address_space, local.spoke_cidr_ranges))
    content {
      name                   = "${each.key}_${replace(replace(route.value, ".", "-"), "/", "_")}"
      address_prefix         = route.value
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = local.gateway_address_by_hub_id[each.key]
    }
  }
}

resource "azurerm_subnet_route_table_association" "gateway" {
  for_each = {
    for k, v in local.azurerm_virtual_network_config :
    k => v
    if contains(local.route_table_hub_ids, k)
  }

  subnet_id      = local.azurerm_subnet_config["${each.key}_gateway"].id
  route_table_id = azurerm_route_table.gateway[each.key].id
}

# The following route table and association ensures that the hub non-production NVA is able to still access the on-premise IP ranges after advertising itself via BGP

# resource "azurerm_route_table" "onprem_dc1_nonprod_vpn" {
#   name                          = "onprem_dc1_nonprod-vpn-routetable"
#   location                      = var.location
#   resource_group_name           = azurerm_resource_group.onprem_dc1_nonprod.name
#   disable_bgp_route_propagation = false

#   route {
#     name           = "nonprod_10-226-0-0_16"
#     address_prefix = "10.226.0.0/16"
#     next_hop_type  = "VirtualNetworkGateway"
#     # next_hop_type          = "VirtualAppliance"
#     # next_hop_in_ip_address = local.gateway_address_by_hub_id["hub_nonprod"]
#   }
# }

# resource "azurerm_subnet_route_table_association" "onprem_dc1_nonprod_gateway" {
#   subnet_id      = azurerm_subnet.onprem_dc1_nonprod_gateway.id
#   route_table_id = azurerm_route_table.onprem_dc1_nonprod_vpn.id
# }

# resource "azurerm_subnet_route_table_association" "onprem_dc1_nonprod_default" {
#   subnet_id      = azurerm_subnet.onprem_dc1_nonprod_default.id
#   route_table_id = azurerm_route_table.onprem_dc1_nonprod_vpn.id
# }

# # The following route table and association ensures that the hub non-production NVA is able to still access the on-premise IP ranges after advertising itself via BGP

# resource "azurerm_route_table" "hub_nonprod_vpn" {
#   name                          = "hub-nonprod-vpn-routetable"
#   location                      = var.location
#   resource_group_name           = azurerm_resource_group.hub_nonprod.name
#   disable_bgp_route_propagation = false

#   route {
#     name           = "nonprod-cidr0"
#     address_prefix = "10.0.0.0/16"
#     next_hop_type  = "VirtualNetworkGateway"
#   }
# }

# resource "azurerm_subnet_route_table_association" "hub_nonprod_nva" {
#   subnet_id      = azurerm_subnet.hub_nonprod_nva.id
#   route_table_id = azurerm_route_table.hub_nonprod_vpn.id
# }

# # The following route table and association ensures that the hub internet NVA is able to still access the Internet after advertising itself via BGP

# resource "azurerm_route_table" "default_internet" {
#   name                          = "default-internet-routetable"
#   location                      = var.location
#   resource_group_name           = azurerm_resource_group.hub_internet.name
#   disable_bgp_route_propagation = false

#   route {
#     name           = "internet"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "Internet"
#   }
# }

# resource "azurerm_subnet_route_table_association" "hub_internet_nva" {
#   subnet_id      = azurerm_subnet.hub_internet_nva.id
#   route_table_id = azurerm_route_table.default_internet.id
# }

# # The following route table and association ensures that the hub management NVA is able to still access the on-premise IP ranges after advertising itself via BGP

# resource "azurerm_route_table" "hub_management_vpn" {
#   name                          = "hub-management-vpn-routetable"
#   location                      = var.location
#   resource_group_name           = azurerm_resource_group.hub_management.name
#   disable_bgp_route_propagation = false

#   route {
#     name           = "management-cidr49"
#     address_prefix = "10.49.0.0/16"
#     next_hop_type  = "VirtualNetworkGateway"
#   }

#   route {
#     name           = "management-cidr50"
#     address_prefix = "10.50.0.0/16"
#     next_hop_type  = "VirtualNetworkGateway"
#   }
# }

# resource "azurerm_subnet_route_table_association" "hub_management_nva" {
#   subnet_id      = azurerm_subnet.hub_management_nva.id
#   route_table_id = azurerm_route_table.hub_management_vpn.id
# }

# The following route table and association ensures that the non-production spokes  is able to still access the on-premise IP ranges after advertising itself via BGP

resource "azurerm_route_table" "management_spoke" {
  name                          = "management-spoke-udr"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.hub_nonprod.name
  disable_bgp_route_propagation = false

  # route {
  #   name                   = "internet"
  #   address_prefix         = "0.0.0.0/0"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = module.virtual_machines["i-h-rras-vm001"].private_ip_address
  # }

  route {
    name                   = "rfc-1918-10-226-0-0-16"
    address_prefix         = "10.226.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = module.virtual_machines["m-h-rras-vm001"].private_ip_address
  }

  # route {
  #   name                   = "rfc-1918-172"
  #   address_prefix         = "172.16.0.0/12"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = module.virtual_machines["m-h-rras-vm001"].private_ip_address
  # }

  # route {
  #   name                   = "rfc-1918-192"
  #   address_prefix         = "192.168.0.0/16"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = module.virtual_machines["m-h-rras-vm001"].private_ip_address
  # }

  # route {
  #   name                   = "management-49"
  #   address_prefix         = "10.49.0.0/16"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = module.virtual_machines["m-h-rras-vm001"].private_ip_address
  # }

  # route {
  #   name                   = "management-50"
  #   address_prefix         = "10.50.0.0/16"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = module.virtual_machines["m-h-rras-vm001"].private_ip_address
  # }
}

resource "azurerm_subnet_route_table_association" "spoke" {
  subnet_id      = azurerm_subnet.spoke_management_default.id
  route_table_id = azurerm_route_table.management_spoke.id
}
