terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
      
    } 
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "my-resource-group"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "my-resource-group"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "vm_public_ip"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "eastus"
  resource_group_name = "my-resource-group"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}
resource "azurerm_network_security_group" "main" {
  name                = "arti_nsg"
  location            = "eastus"
  resource_group_name = "my-resource-group"

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-java-vm"
  location              = "eastus"
  resource_group_name   = "my-resource-group"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = "true"
	


  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true
  
  plan {
    name      = "tomcat-ubuntu"
    publisher = "cloud-infrastructure-services"
    product   =  "tomcat-ubuntu"
  }

  storage_image_reference {
    publisher = "cloud-infrastructure-services"
    offer     = "tomcat-ubuntu"
    sku       = "tomcat-ubuntu"
    version   = "latest"
  }
  storage_os_disk {
    name              = "artiosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "artimachine"
    admin_username = "arti"
    admin_password = "Arti123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine_extension" "main" {
  name                  = "artimachine"
  #location             = "eastus"
  #resource_group_name  = "my-resource-group"
  virtual_machine_id    =  azurerm_virtual_machine.main.id
  publisher             = "Microsoft.Azure.Extensions"
  type                  = "CustomScript"
  type_handler_version  = "2.0"

  settings = <<SETTINGS
  {
    "commandToExecute": "sudo systemctl start tomcat && sudo chmod -R 777 /opt/tomcat/9_37"
  }
SETTINGS

  tags =  {
    environment = "staging"
  }
}





