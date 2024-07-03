terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-bkp-rg"
    storage_account_name = "tfstatebkp"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}