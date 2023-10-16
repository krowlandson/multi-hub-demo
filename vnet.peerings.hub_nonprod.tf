locals {
  hub_nonprod_spokes = [
    "spoke_nonprod_001",
    "spoke_nonprod_002",
    "spoke_nonprod_003",
  ]
}

# Connect hub_nonprod to spoke virtual networks

resource "azurerm_virtual_network_peering" "hub_nonprod_to_spoke" {
  for_each = toset(local.hub_nonprod_spokes)

  name                      = "hub_nonprod_to_${each.value}"
  resource_group_name       = local.azurerm_virtual_network_config["hub_nonprod"].resource_group_name
  virtual_network_name      = local.azurerm_virtual_network_config["hub_nonprod"].name
  remote_virtual_network_id = local.azurerm_virtual_network_config[each.value].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false

}

# Connect spokes to hub_nonprod virtual networks

resource "azurerm_virtual_network_peering" "spoke_to_hub_nonprod" {
  for_each = toset(local.hub_nonprod_spokes)

  name                      = "${each.value}_to_hub_nonprod"
  resource_group_name       = local.azurerm_virtual_network_config[each.value].resource_group_name
  virtual_network_name      = local.azurerm_virtual_network_config[each.value].name
  remote_virtual_network_id = local.azurerm_virtual_network_config["hub_nonprod"].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

}

# Connect hub_nonprod to hub_management

# resource "azurerm_virtual_network_peering" "hub_nonprod_to_hub_management" {
#   name                      = "hub_nonprod_to_hub_management"
#   resource_group_name       = azurerm_resource_group.hub_nonprod.name
#   virtual_network_name      = azurerm_virtual_network.hub_nonprod.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_management.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false

#   # The following dependency is needed when enabling use_remote_gateways
#   # depends_on = [
#   #   azurerm_virtual_network_gateway.hub_management_vpn_gateway,
#   #   azurerm_virtual_network_peering.hub_management_to_hub_nonprod,
#   # ]
# }
