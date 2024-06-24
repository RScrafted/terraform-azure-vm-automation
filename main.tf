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
resource "azurerm_resource_group" "autoazvm-test-rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Project     = "Automated Azure VM Deployment"
    Environment = "Test"
    Owner       = "Rachit"
  }
}

# Below starts critical resources for this Project

resource "azurerm_virtual_network" "autoazvm-test-rg-vnet" {
  name                = "${var.resource_group_name}-vnet"
  resource_group_name = var.resource_group_name # azure_resource_group.autoazvm-test-rg.name is an alternate. Ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine
  location            = var.location            # azurerm_resource_group.autoazvm-test-rg.location is an alternate. Ref: ""
  address_space       = ["10.0.0.0/16"]

  depends_on = [azurerm_resource_group.autoazvm-test-rg]
}

# Location selection via portal is mandatory, not in here!
resource "azurerm_subnet" "autoazvm-test-rg-subnet" {
  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.autoazvm-test-rg-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "autoazvm-test-rg-ni" {
  name                = var.network_interface_name
  resource_group_name = var.resource_group_name
  location            = azurerm_resource_group.autoazvm-test-rg.location

  ip_configuration {                                                         # Mandatory
    name                          = "${var.network_interface_name}-internal" # verify name after deployment
    subnet_id                     = azurerm_subnet.autoazvm-test-rg-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "autoazvm-test-rg-vm" {
  name                  = "${var.resource_group_name}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.autoazvm-test-rg-ni.id] # If I plan to add multiple NIC, I can use azurevm_network_interface.autoazvm-test-rg-ni.*.id
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.resource_group_name}-osdisk"
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
    computer_name  = "myUbuntu" # hostname
    admin_username = "avengers"
    admin_password = "Assemble@2024" # Just a Marvel fan.. :) I never use these as credentials otherwise!
  }

  os_profile_linux_config {
    disable_password_authentication = false # being a test and short-lived environment with password verified, this is set to false.
  }

  tags = {
    Project     = "Automated Azure VM Deployment"
    Environment = "Test"
    Owner       = "Rachit"
  }
}