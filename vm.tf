# Create network interface
resource "azurerm_network_interface" "winnic" {
  name                          = var.network_interface_name
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = "true"

  ip_configuration {
    name                          = var.ip_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.winnic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create Windows virtual machine

resource "azurerm_windows_virtual_machine" "windowsvm" {
  name                       = var.windows_vm_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  size                       = var.vm_size
  admin_username             = "siva"
  admin_password             = "India@123456"
  network_interface_ids      = [azurerm_network_interface.winnic.id]

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






