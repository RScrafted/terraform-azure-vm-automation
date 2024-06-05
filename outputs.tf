# I personally prefer using below syntax:
output "resource_group_name" {
  value = azurerm_resource_group.autoazvm-test-rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.autoazvm-test-rg-vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.autoazvm-test-rg-subnet.id
}

output "network_interface_ids" {
  value = azurerm_network_interface.autoazvm-test-rg-ni.id
}

output "virtual_machine_name" {
  value = azurerm_virtual_machine.autoazvm-test-rg-vm.name
}