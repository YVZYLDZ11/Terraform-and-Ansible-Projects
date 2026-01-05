terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# --- RESOURCE GROUP ---
resource "azurerm_resource_group" "main_rg" {
  name     = "Terraform-RG"
  location = "francecentral"
}

# --- NETWORKING ---

# Virtual Network
resource "azurerm_virtual_network" "main_vnet" {
  name                = "F1-Production-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
}

# Subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "Web-Servers-Subnet"
  resource_group_name  = azurerm_resource_group.main_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# --- SECURITY ---

# Network Security Group (NSG)
resource "azurerm_network_security_group" "web_nsg" {
  name                = "F1-Security-Group"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  # Rule 1: Allow SSH (Port 22)
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Rule 2: Allow HTTP (Port 80)
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# --- COMPUTE (VIRTUAL MACHINE) ---

# Public IP Address
resource "azurerm_public_ip" "server_public_ip" {
  name                = "F1-Server-PublicIP"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name
  allocation_method   = "Dynamic"
}

# Network Interface (NIC)
resource "azurerm_network_interface" "server_nic" {
  name                = "F1-Server-NIC"
  location            = azurerm_resource_group.main_rg.location
  resource_group_name = azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.server_public_ip.id
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "web_server_vm" {
  name                = "F1-Telemetry-Server"
  resource_group_name = azurerm_resource_group.main_rg.name
  location            = azurerm_resource_group.main_rg.location
  size                = "Standard_B1s"
  admin_username      = "f1admin"
  
  # Note: For production, use SSH keys instead of passwords
  admin_password                  = "*****************"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.server_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}