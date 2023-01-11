resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "terraform_state" {
  name     = "terraformstaterg"
  location = "westus2"
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "terraformstatesa${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    name        = "zztalk-demo-tf-state"
    environment = "demo"
    source      = "terraform"
  }
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraformstatesc"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}