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

locals {
  resource_group="app-grp"
  location="North Europe"
}


resource "tls_private_key" "linux_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# We want to save the private key to our machine
# We can then use this key to connect to our Linux VM

resource "local_file" "linuxkey" {
  filename="linuxkey.pem"  
  content=tls_private_key.linux_key.private_key_pem 
}

resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_virtual_network" "app_network" {
  name                = "app-network"
  location            = local.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = "SubnetA"
  resource_group_name  = local.resource_group
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.app_network
  ]
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = "app-public-ip"
  resource_group_name = local.resource_group
  location            = local.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.app_grp
  ]
}
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "app_interface" {
  name                = "app-interface"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.app_public_ip.id
  }
  depends_on = [
    azurerm_virtual_network.app_network,
    azurerm_public_ip.app_public_ip,
    azurerm_network_security_group.example
  ]
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.app_interface.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = "linuxvm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "linuxusr"
  admin_password      = "Arati@2023M"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.app_interface.id,
  ]
  //admin_ssh_key {
  //  username   = "linuxusr"
  //  public_key = tls_private_key.linux_key.public_key_openssh
  //}
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.app_interface,
    //tls_private_key.linux_key,
    azurerm_network_security_group.example
  ]
  
  

# Provision the virtual machine using cloud-init
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      
      "sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose"
      
      //"sudo apt-get update && sudo apt-get install -y apt-transport-https",
      //"curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
      //"echo 'deb https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      //"sudo apt-get update",
      //"sudo apt-get install -y kubelet kubeadm kubectl",

      //"mkdir -p $HOME/.kube",
      //"sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      //"sudo chown $(id -u):$(id -g) $HOME/.kube/config"

      
      //"mkdir -p $HOME/.kube",
      //"sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      //"sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      //"kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml"
    ]

    connection {
    type        = "ssh"
    host        = azurerm_public_ip.app_public_ip.ip_address
    user        = "linuxusr"
    password    = "Arati@2023M"
    //private_key = tls_private_key.linux_key.private_key_pem
    timeout     = "15m"
  }
  }
  
}



