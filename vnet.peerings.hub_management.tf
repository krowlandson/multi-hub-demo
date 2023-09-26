locals {
  hub_management_spokes = [
    "spoke_nonprod_001",
    "spoke_nonprod_002",
    "spoke_nonprod_003",
    "spoke_management",
    "hub_nonprod",
    "hub_internet",
  ]
}

# Connect hub_management to spoke virtual networks

resource "azurerm_virtual_network_peering" "hub_management_to_spoke" {
  for_each = toset(local.hub_management_spokes)

  name                      = "hub_management_to_${each.value}"
  resource_group_name       = local.azurerm_virtual_network_config["hub_management"].resource_group_name
  virtual_network_name      = local.azurerm_virtual_network_config["hub_management"].name
  remote_virtual_network_id = local.azurerm_virtual_network_config[each.value].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

}

# Connect spokes to hub_management virtual networks

resource "azurerm_virtual_network_peering" "spoke_to_hub_management" {
  for_each = toset(local.hub_management_spokes)

  name                      = "${each.value}_to_hub_management"
  resource_group_name       = local.azurerm_virtual_network_config[each.value].resource_group_name
  virtual_network_name      = local.azurerm_virtual_network_config[each.value].name
  remote_virtual_network_id = local.azurerm_virtual_network_config["hub_management"].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false

}

# # Connect hub_management to hub_nonprod

# resource "azurerm_virtual_network_peering" "hub_management_to_hub_nonprod" {
#   name                      = "hub_management_to_hub_nonprod"
#   resource_group_name       = azurerm_resource_group.hub_management.name
#   virtual_network_name      = azurerm_virtual_network.hub_management.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_nonprod.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# # Connect hub_management to hub_internet

# resource "azurerm_virtual_network_peering" "hub_management_to_hub_internet" {
#   name                      = "hub_management_to_hub_internet"
#   resource_group_name       = azurerm_resource_group.hub_management.name
#   virtual_network_name      = azurerm_virtual_network.hub_management.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_internet.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# # Connect hub_management to hub_nonprod_ars

# # resource "azurerm_virtual_network_peering" "hub_management_to_hub_nonprod_ars" {
# #   name                      = "hub_management_to_hub_nonprod_ars"
# #   resource_group_name       = azurerm_resource_group.hub_management.name
# #   virtual_network_name      = azurerm_virtual_network.hub_management.name
# #   remote_virtual_network_id = azurerm_virtual_network.hub_nonprod_ars.id

# #   allow_virtual_network_access = true
# #   allow_forwarded_traffic      = false
# #   allow_gateway_transit        = false
# #   use_remote_gateways          = false
# # }

# # Connect hub_management and spoke_nonprod_001

# resource "azurerm_virtual_network_peering" "hub_management_to_spoke_nonprod_001" {
#   name                      = "hub_management_to_spoke_nonprod_001"
#   resource_group_name       = azurerm_resource_group.hub_management.name
#   virtual_network_name      = azurerm_virtual_network.hub_management.name
#   remote_virtual_network_id = azurerm_virtual_network.spoke_nonprod_001.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "spoke_nonprod_001_to_hub_management" {
#   name                      = "spoke_nonprod_001_to_hub_management"
#   resource_group_name       = azurerm_resource_group.spoke_nonprod_001.name
#   virtual_network_name      = azurerm_virtual_network.spoke_nonprod_001.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_management.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# # Connect hub_management and spoke_nonprod_002

# resource "azurerm_virtual_network_peering" "hub_management_to_spoke_nonprod_002" {
#   name                      = "hub_management_to_spoke_nonprod_002"
#   resource_group_name       = azurerm_resource_group.hub_management.name
#   virtual_network_name      = azurerm_virtual_network.hub_management.name
#   remote_virtual_network_id = azurerm_virtual_network.spoke_nonprod_002.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "spoke_nonprod_002_to_hub_management" {
#   name                      = "spoke_nonprod_002_to_hub_management"
#   resource_group_name       = azurerm_resource_group.spoke_nonprod_002.name
#   virtual_network_name      = azurerm_virtual_network.spoke_nonprod_002.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_management.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# # Connect hub_management and spoke_nonprod_003

# resource "azurerm_virtual_network_peering" "hub_management_to_spoke_nonprod_003" {
#   name                      = "hub_management_to_spoke_nonprod_003"
#   resource_group_name       = azurerm_resource_group.hub_management.name
#   virtual_network_name      = azurerm_virtual_network.hub_management.name
#   remote_virtual_network_id = azurerm_virtual_network.spoke_nonprod_003.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "spoke_nonprod_003_to_hub_management" {
#   name                      = "spoke_nonprod_003_to_hub_management"
#   resource_group_name       = azurerm_resource_group.spoke_nonprod_003.name
#   virtual_network_name      = azurerm_virtual_network.spoke_nonprod_003.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_management.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# # Connect hub_management and spoke_management

# resource "azurerm_virtual_network_peering" "hub_management_to_spoke_management" {
#   name                      = "hub_management_to_spoke_management"
#   resource_group_name       = azurerm_resource_group.hub_management.name
#   virtual_network_name      = azurerm_virtual_network.hub_management.name
#   remote_virtual_network_id = azurerm_virtual_network.spoke_management.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
# }

# resource "azurerm_virtual_network_peering" "spoke_management_to_hub_management" {
#   name                      = "spoke_management_to_hub_management"
#   resource_group_name       = azurerm_resource_group.spoke_management.name
#   virtual_network_name      = azurerm_virtual_network.spoke_management.name
#   remote_virtual_network_id = azurerm_virtual_network.hub_management.id

#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = false
#   # use_remote_gateways          = true

#   # # The following dependency is needed when enabling use_remote_gateways
#   # depends_on = [
#   #   azurerm_virtual_network_gateway.hub_management_vpn_gateway,
#   #   azurerm_virtual_network_peering.hub_management_to_spoke_management,
#   # ]
# }
