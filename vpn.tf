# Public IPs for VPN gateways

resource "azurerm_public_ip" "hub_nonprod_pip" {
  name                = "${azurerm_resource_group.hub_nonprod.name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "hub_nonprod_pip_2" {
  name                = "${azurerm_resource_group.hub_nonprod.name}-pip2"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "hub_management_pip" {
  name                = "${azurerm_resource_group.hub_management.name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_management.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "hub_management_pip_2" {
  name                = "${azurerm_resource_group.hub_management.name}-pip2"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_management.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "onprem_dc1_nonprod_pip" {
  name                = "${azurerm_resource_group.onprem_dc1_nonprod.name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "onprem_dc1_nonprod_pip_2" {
  name                = "${azurerm_resource_group.onprem_dc1_nonprod.name}-pip2"
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "onprem_dc1_management_pip" {
  name                = "${azurerm_resource_group.onprem_dc1_management.name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_dc1_management.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

resource "azurerm_public_ip" "onprem_dc1_management_pip_2" {
  name                = "${azurerm_resource_group.onprem_dc1_management.name}-pip2"
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_dc1_management.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

# VPN gateways

resource "azurerm_virtual_network_gateway" "hub_nonprod_vpn_gateway" {
  name                = "${azurerm_resource_group.hub_nonprod.name}-vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_nonprod.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = "VpnGw2AZ"
  generation    = "Generation2"
  active_active = true

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub_nonprod_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_nonprod_gateway.id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.hub_nonprod_pip_2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_nonprod_gateway.id
  }
}

resource "azurerm_virtual_network_gateway" "hub_management_vpn_gateway" {
  name                = "${azurerm_resource_group.hub_management.name}-vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_management.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = "VpnGw2AZ"
  generation    = "Generation2"
  active_active = true

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub_management_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_management_gateway.id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.hub_management_pip_2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_management_gateway.id
  }
}

resource "azurerm_virtual_network_gateway" "onprem_dc1_nonprod_vpn_gateway" {
  name                = "${azurerm_resource_group.onprem_dc1_nonprod.name}-vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = "VpnGw2AZ"
  generation    = "Generation2"
  active_active = true

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_dc1_nonprod_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_dc1_nonprod_gateway.id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.onprem_dc1_nonprod_pip_2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_dc1_nonprod_gateway.id
  }
}

resource "azurerm_virtual_network_gateway" "onprem_dc1_management_vpn_gateway" {
  name                = "${azurerm_resource_group.onprem_dc1_management.name}-vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.onprem_dc1_management.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = "VpnGw2AZ"
  generation    = "Generation2"
  active_active = true

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_dc1_management_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_dc1_management_gateway.id
  }
  ip_configuration {
    name                          = "vnetGatewayConfig2"
    public_ip_address_id          = azurerm_public_ip.onprem_dc1_management_pip_2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_dc1_management_gateway.id
  }
}

# Local network gateways

resource "azurerm_local_network_gateway" "hub_nonprod_0" {
  name                = "hub_nonprod_0"
  resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name
  location            = azurerm_resource_group.onprem_dc1_nonprod.location
  gateway_address     = azurerm_public_ip.hub_nonprod_pip.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.hub_nonprod.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_001.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_002.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_003.address_space,
  ])
}

resource "azurerm_local_network_gateway" "hub_nonprod_1" {
  name                = "hub_nonprod_1"
  resource_group_name = azurerm_resource_group.onprem_dc1_nonprod.name
  location            = azurerm_resource_group.onprem_dc1_nonprod.location
  gateway_address     = azurerm_public_ip.hub_nonprod_pip_2.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.hub_nonprod.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_001.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_002.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_003.address_space,
  ])
}

resource "azurerm_local_network_gateway" "onprem_dc1_nonprod_0" {
  name                = "onprem_dc1_nonprod_0"
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  location            = azurerm_resource_group.hub_nonprod.location
  gateway_address     = azurerm_public_ip.onprem_dc1_nonprod_pip.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.onprem_dc1_nonprod.address_space,
  ])
}

resource "azurerm_local_network_gateway" "onprem_dc1_nonprod_1" {
  name                = "onprem_dc1_nonprod_1"
  resource_group_name = azurerm_resource_group.hub_nonprod.name
  location            = azurerm_resource_group.hub_nonprod.location
  gateway_address     = azurerm_public_ip.onprem_dc1_nonprod_pip_2.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.onprem_dc1_nonprod.address_space,
  ])
}

resource "azurerm_local_network_gateway" "hub_management_0" {
  name                = "hub_management_0"
  resource_group_name = azurerm_resource_group.onprem_dc1_management.name
  location            = azurerm_resource_group.onprem_dc1_management.location
  gateway_address     = azurerm_public_ip.hub_management_pip.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.hub_management.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_001.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_002.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_003.address_space,
    local.azurerm_virtual_network_config.spoke_management.address_space,
  ])
}

resource "azurerm_local_network_gateway" "hub_management_1" {
  name                = "hub_management_1"
  resource_group_name = azurerm_resource_group.onprem_dc1_management.name
  location            = azurerm_resource_group.onprem_dc1_management.location
  gateway_address     = azurerm_public_ip.hub_management_pip_2.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.hub_management.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_001.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_002.address_space,
    local.azurerm_virtual_network_config.spoke_nonprod_003.address_space,
    local.azurerm_virtual_network_config.spoke_management.address_space,
  ])
}

resource "azurerm_local_network_gateway" "onprem_dc1_management_0" {
  name                = "onprem_dc1_management_0"
  resource_group_name = azurerm_resource_group.hub_management.name
  location            = azurerm_resource_group.hub_management.location
  gateway_address     = azurerm_public_ip.onprem_dc1_management_pip.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.onprem_dc1_management.address_space,
  ])
}

resource "azurerm_local_network_gateway" "onprem_dc1_management_1" {
  name                = "onprem_dc1_management_1"
  resource_group_name = azurerm_resource_group.hub_management.name
  location            = azurerm_resource_group.hub_management.location
  gateway_address     = azurerm_public_ip.onprem_dc1_management_pip_2.ip_address
  address_space = flatten([
    local.azurerm_virtual_network_config.onprem_dc1_management.address_space,
  ])
}

# VPN connection shared keys

resource "random_password" "shared_key" {
  length           = 30
  upper            = false
  lower            = true
  min_lower        = 10
  numeric          = true
  min_numeric      = 10
  special          = true
  override_special = "-"
  min_special      = 5
}

# VPN connections

resource "azurerm_virtual_network_gateway_connection" "hub_nonprod_to_onprem_dc1_nonprod_0" {
  name                = "hub_nonprod_to_onprem_dc1_nonprod_0"
  location            = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_dc1_nonprod_0.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "hub_nonprod_to_onprem_dc1_nonprod_1" {
  name                = "hub_nonprod_to_onprem_dc1_nonprod_1"
  location            = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_nonprod_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_dc1_nonprod_1.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "onprem_dc1_nonprod_to_hub_nonprod_0" {
  name                = "onprem_dc1_nonprod_to_hub_nonprod_0"
  location            = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_nonprod_0.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "onprem_dc1_nonprod_to_hub_nonprod_1" {
  name                = "onprem_dc1_nonprod_to_hub_nonprod_1"
  location            = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem_dc1_nonprod_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_nonprod_1.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "hub_management_to_onprem_dc1_management_0" {
  name                = "hub_management_to_onprem_dc1_management_0"
  location            = azurerm_virtual_network_gateway.hub_management_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.hub_management_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_management_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_dc1_management_0.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "hub_management_to_onprem_dc1_management_1" {
  name                = "hub_management_to_onprem_dc1_management_1"
  location            = azurerm_virtual_network_gateway.hub_management_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.hub_management_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_management_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_dc1_management_1.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "onprem_dc1_management_to_hub_management_0" {
  name                = "onprem_dc1_management_to_hub_management_0"
  location            = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_management_0.id

  shared_key = random_password.shared_key.result
}

resource "azurerm_virtual_network_gateway_connection" "onprem_dc1_management_to_hub_management_1" {
  name                = "onprem_dc1_management_to_hub_management_1"
  location            = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway.location
  resource_group_name = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem_dc1_management_vpn_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_management_1.id

  shared_key = random_password.shared_key.result
}

