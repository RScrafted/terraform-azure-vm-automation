terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.105.0" # The operator >= programmatically states “greater than or equal to” in code.
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false # This if required
    }
  }
}
resource "azurerm_resource_group" "autoazvm-dev-rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Below starts critical resources for this Project

resource "azurerm_virtual_network" "autoazvm-dev-vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.autoazvm-dev-rg.name     # explicit referenced resource to ensure proper dependency handeling
  location            = azurerm_resource_group.autoazvm-dev-rg.location # explicit referenced resource to ensure proper dependency handeling
  address_space       = ["192.168.100.0/24"]                            # Using Class C address for smaller network demonstration

  depends_on = [azurerm_resource_group.autoazvm-dev-rg]
}

# Location selection via portal is mandatory, not in here!
resource "azurerm_subnet" "autoazvm-dev-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.autoazvm-dev-rg.name
  virtual_network_name = azurerm_virtual_network.autoazvm-dev-vnet.name
  address_prefixes     = ["192.168.100.0/25"]

  depends_on = [azurerm_resource_group.autoazvm-dev-rg, azurerm_virtual_network.autoazvm-dev-vnet]
}

resource "azurerm_network_interface" "autoazvm-dev-ni" {
  name                = var.network_interface_name
  resource_group_name = azurerm_resource_group.autoazvm-dev-rg.name
  location            = azurerm_resource_group.autoazvm-dev-rg.location

  tags = var.tags

  ip_configuration {                                          # Mandatory
    name                          = var.ip_configuration_name # verify name after deployment
    subnet_id                     = azurerm_subnet.autoazvm-dev-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "192.168.100.4"
    public_ip_address_id          = azurerm_public_ip.autoazvm-dev-pip.id # Allows Linux VM to attach PUBLIC IP automatically, needed to connect using terminal remotely
  }
}

resource "azurerm_public_ip" "autoazvm-dev-pip" {
  name                    = var.public_ip_name
  resource_group_name     = azurerm_resource_group.autoazvm-dev-rg.name
  location                = azurerm_resource_group.autoazvm-dev-rg.location
  allocation_method       = "Static"
  idle_timeout_in_minutes = "4"
  tags                    = var.tags
}

resource "azurerm_network_security_group" "autoazvm-dev-nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.autoazvm-dev-rg.location
  resource_group_name = azurerm_resource_group.autoazvm-dev-rg.name

  tags = var.tags
  /*
  security_rule {
    name                       = "DefaultDenyAllInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
*/
  security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# it is important to use below resource especially

resource "azurerm_subnet_network_security_group_association" "autoazvm-dev-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.autoazvm-dev-subnet.id
  network_security_group_id = azurerm_network_security_group.autoazvm-dev-nsg.id
}

resource "azurerm_virtual_machine" "autoazvm-dev-vm" {
  name                  = var.virtual_machine_name
  location              = azurerm_resource_group.autoazvm-dev-rg.location
  resource_group_name   = azurerm_resource_group.autoazvm-dev-rg.name
  network_interface_ids = [azurerm_network_interface.autoazvm-dev-ni.id] # alternate to add all the NIC --> [azurevm_network_interface.autoazvm-dev-ni.*.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = var.storage_os_disk
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Handy command: az vm image list --output table
  # Handy ref: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/cli-ps-findimage#code-try-3

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password # this is specified because disable_password_authentication = false as below.
  }

  os_profile_linux_config {
    disable_password_authentication = false # being a test and short-lived environment with password verified, this is set to false.
  }

  tags = var.tags
}