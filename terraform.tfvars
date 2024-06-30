# Skip any of the below to receive a prompt. Since I will automate, I keep!
resource_group_name = "autoazvm-dev-rg"

# Avoid skiping defaults for Resource Group, incorrect manual entry destroys the existing RG and related resources if any.
location = "eastus"

virtual_network_name = "autoazvm-dev-vnet"

subnet_name = "autoazvm-dev-subnet"

network_interface_name = "autoazvm-dev-ni"

ip_configuration_name = "autoazvm-dev-ipconfig"

virtual_machine_name = "autoazvm-dev-vm"

vm_size = "standard_ds1_v2"

storage_os_disk = "autoazvm-dev-osdisk"

computer_name = "myUbuntu"

admin_username = "tonystark"

admin_password = "IAmIr0nMan@4ev3r"

tags = {
  "Project"     = "Automated"
  "Environment" = "Development"
  "Owner"       = "Rachit"
}