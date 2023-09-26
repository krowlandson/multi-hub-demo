# import {
#   to = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/hub_nonprod/providers/Microsoft.Network/virtualNetworkGateways/hub_nonprod-vpn-gateway"
# }

# import {
#   to = azurerm_virtual_network_gateway.hub_management_vpn_gateway
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/hub_management/providers/Microsoft.Network/virtualNetworkGateways/hub_management-vpn-gateway"
# }

# import {
#   to = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/onprem_dc1_nonprod/providers/Microsoft.Network/virtualNetworkGateways/onprem_dc1_nonprod-vpn-gateway"
# }

# import {
#   to = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/onprem_dc1_management/providers/Microsoft.Network/virtualNetworkGateways/onprem_dc1_management-vpn-gateway"
# }

# import {
#   to = module.virtual_machines["n-dc-test-vm001"].azurerm_virtual_machine_extension.network_watcher
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/onprem_dc1_nonprod/providers/Microsoft.Compute/virtualMachines/n-dc-test-vm001/extensions/AzureNetworkWatcherExtension"
# }

# import {
#   to = azurerm_route_server.hub_ars
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/hub_ars/providers/Microsoft.Network/virtualHubs/ars-h-routerserver"
# }

# import {
#   to = azurerm_subnet_route_table_association.onprem_dc1_nonprod_default
#   id = "/subscriptions/eecca634-8cff-42d8-bf2a-385144ab1637/resourceGroups/onprem_dc1_nonprod/providers/Microsoft.Network/virtualNetworks/n-dc-vnet001/subnets/Default"
# }