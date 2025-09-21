resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
  
}
resource "azurerm_virtual_network" "vnet" {
  name                = "da-aks-vnet"
  address_space       = var.vnet_cidr
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "aks_sys_subnet" {
  name                 = "aks-sys-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_sys_subnet_prefix
}


resource "azurerm_subnet" "aks_usr_subnet" {
  name                 = "aks-usr-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_usr_subnet_prefix
}


resource "azurerm_application_security_group" "web_asg" {
  name                = "asg-aks-web-nodes"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



resource "azurerm_network_security_group" "da-aks_nsg" {
  name                = "da-aks-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_usr_subnet.id
  network_security_group_id = azurerm_network_security_group.da-aks_nsg.id
}

resource "azurerm_network_security_rule" "allow_web_inbound" {
  name                        = "AllowWebTrafficToWebNodes"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.allowed_ports
  source_address_prefix       = var.source_address_prefix
  destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.da-aks_nsg.name
}
