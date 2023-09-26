variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "script_path" {
  type    = string
  default = null
}

variable "enable_ip_forwarding" {
  type    = bool
  default = false
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding = var.enable_ip_forwarding

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_D2_v5"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

locals {
  scriptName     = "bootstrap.ps1"
  scriptRendered = filebase64(var.script_path)
}

resource "azurerm_virtual_machine_extension" "bootstrap" {
  for_each = toset([var.script_path])

  name                 = "bootstrap"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    commandToExecute = "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${local.scriptRendered}')) | Out-File -filepath ${local.scriptName}\" && powershell -ExecutionPolicy Unrestricted -File ${local.scriptName}"
  })

}

resource "azurerm_virtual_machine_extension" "network_watcher" {
  name                 = "network_watcher"
  virtual_machine_id   = azurerm_windows_virtual_machine.this.id
  publisher            = "Microsoft.Azure.NetworkWatcher"
  type                 = "NetworkWatcherAgentWindows"
  type_handler_version = "1.4"

  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
}

output "private_ip_address" {
  value = azurerm_network_interface.this.private_ip_address
}
