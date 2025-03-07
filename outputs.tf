# I personally prefer using below syntax:
output "resource_group_name" {
  value = azurerm_resource_group.autoazvm-dev-rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.autoazvm-dev-vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.autoazvm-dev-subnet.id
}

output "network_interface_ids" {
  value = azurerm_network_interface.autoazvm-dev-ni.id
}

# get Private IP here

# get Public IP here


output "network_security_group_name" {
  value = azurerm_network_security_group.autoazvm-dev-nsg.name
}

output "virtual_machine_name" {
  value = azurerm_virtual_machine.autoazvm-dev-vm.name
}
