terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name = "terraformstaterg"
  #   storage_account_name = "terraformstatesaf5r49"
  #   container_name = "terraformstatesc"
  #   key = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
