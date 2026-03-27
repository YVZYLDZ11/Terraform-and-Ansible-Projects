# 1. Resource Group: The main container for our F1 infrastructure
resource "azurerm_resource_group" "f1_rg" {
  name     = var.rg_name
  location = var.location
}

# 2. Virtual Network (VNet): The core communication backbone
resource "azurerm_virtual_network" "f1_vnet" {
  name                = "${var.rg_name}-VNet"
  location            = azurerm_resource_group.f1_rg.location
  resource_group_name = azurerm_resource_group.f1_rg.name
  address_space       = var.vnet_address_space
}

# 3. Trackside Subnet: For edge servers (Public-facing)
resource "azurerm_subnet" "trackside_subnet" {
  name                 = "Trackside-Edge-Subnet"
  resource_group_name  = azurerm_resource_group.f1_rg.name
  virtual_network_name = azurerm_virtual_network.f1_vnet.name
  address_prefixes     = [var.subnet_prefixes[0]]
}

# 4. HQ Database Subnet: For centralized data storage (Isolated/Private)
resource "azurerm_subnet" "hq_subnet" {
  name                 = "HQ-Database-Subnet"
  resource_group_name  = azurerm_resource_group.f1_rg.name
  virtual_network_name = azurerm_virtual_network.f1_vnet.name
  address_prefixes     = [var.subnet_prefixes[1]]
}

# 5. Pitwall Subnet: For engineers' dashboards and analytics
resource "azurerm_subnet" "pitwall_subnet" {
  name                 = "Pitwall-Analytics-Subnet"
  resource_group_name  = azurerm_resource_group.f1_rg.name
  virtual_network_name = azurerm_virtual_network.f1_vnet.name
  address_prefixes     = [var.subnet_prefixes[2]]
}

# 6. Garage Subnet: For car sensors and IoT data
resource "azurerm_subnet" "garage_subnet" {
  name                 = "Garage-IoT-Subnet"
  resource_group_name  = azurerm_resource_group.f1_rg.name
  virtual_network_name = azurerm_virtual_network.f1_vnet.name
  address_prefixes     = [var.subnet_prefixes[3]]
}

# 7. Network Security Group (NSG): Firewall rules for the trackside
resource "azurerm_network_security_group" "trackside_nsg" {
  name                = "Trackside-NSG"
  location            = azurerm_resource_group.f1_rg.location
  resource_group_name = azurerm_resource_group.f1_rg.name

  # Rule: Allow inbound HTTP traffic (Port 80) from anywhere
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ==========================================
# ADVANCED NETWORKING: ROUTING (FREE)
# ==========================================

# 8. Route Table: Traffic Cop for the F1 Subnets
resource "azurerm_route_table" "f1_route_table" {
  name                = "${var.rg_name}-RouteTable"
  location            = azurerm_resource_group.f1_rg.location
  resource_group_name = azurerm_resource_group.f1_rg.name

  # Custom Route: Force all external traffic to go straight to the Internet
  # (Later, we can change this to force traffic through a Firewall Appliance)
  route {
    name                   = "Direct-Internet-Outbound"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

# 9. Associate the Route Table with the Trackside Subnet
resource "azurerm_subnet_route_table_association" "trackside_rt_assoc" {
  subnet_id      = azurerm_subnet.trackside_subnet.id
  route_table_id = azurerm_route_table.f1_route_table.id
}