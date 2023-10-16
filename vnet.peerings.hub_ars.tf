locals {
  hub_ars_spokes = [
    "spoke_nonprod_001",
    "spoke_nonprod_002",
    "spoke_nonprod_003",
    "spoke_management",
  ]
  hub_ars_hubs = [
    "hub_nonprod",
    "hub_internet",
    "hub_management",
  ]
}

# Connect hub_ars to spoke virtual networks

resource "azurerm_virtual_network_peering" "hub_ars_to_spoke" {
  for_each = toset(concat(local.hub_ars_spokes, local.hub_ars_hubs))

  name                      = "hub_ars_to_${each.value}"
  resource_group_name       = local.azurerm_virtual_network_config["hub_ars"].resource_group_name
  virtual_network_name      = local.azurerm_virtual_network_config["hub_ars"].name
  remote_virtual_network_id = local.azurerm_virtual_network_config[each.value].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = contains(local.hub_ars_spokes, each.value)
  use_remote_gateways          = false

}

# Connect spokes to hub_ars virtual networks

resource "azurerm_virtual_network_peering" "spoke_to_hub_ars" {
  for_each = toset(concat(local.hub_ars_spokes, local.hub_ars_hubs))

  name                      = "${each.value}_to_hub_ars"
  resource_group_name       = local.azurerm_virtual_network_config[each.value].resource_group_name
  virtual_network_name      = local.azurerm_virtual_network_config[each.value].name
  remote_virtual_network_id = local.azurerm_virtual_network_config["hub_ars"].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = contains(local.hub_ars_spokes, each.value)

  # The following dependency is needed when enabling use_remote_gateways
  depends_on = [
    azurerm_route_server.hub_ars,
    azurerm_virtual_network_peering.hub_ars_to_spoke,
  ]

}
