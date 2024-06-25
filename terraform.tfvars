# Skip any of the below to receive a prompt. Since I will automate, I keep!
resource_group_name = "autoazvm-dev-rg"

# Avoid skiping defaults for Resource Group, incorrect manual entry destroys the existing RG and related resources if any.
location = "eastus"

azurerm_virtual_network = "autoazvm-dev-vnet"

azurerm_subnet = "autoazvm-dev-subnet"

network_interface_name = "autoazvm-dev-ni"

ip_configuration = "autoazvm-dev-ipconfig"

azurerm_virtual_machine = "autoazvm-dev-vm"

vm_size = "standard_ds1_v2"

storage_os_disk = "autoazvm-dev-osdisk"

computer_name = "myUbuntu"

admin_username = "tonystark"

admin_password = "IAmIr0nMan@4ev3r"

tags = {
  "Project" = "Automated"
  "Environment" = "Development"
  "Owner" = "Rachit"
}