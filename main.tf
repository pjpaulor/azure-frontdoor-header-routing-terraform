# Provider configuration
provider "azurerm" {
  features {}
}

# Generate random names
resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

# Generate hash codes for resource names
locals {
  hash_code = substr(sha1(random_pet.name.id), 0, 5)
}

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-headerrouting-${local.hash_code}"
  location = var.location
}

resource "azurerm_storage_account" "frontends" {
  count             = length(["blue", "green"])
  name              = "st-${element(["frontendblue", "frontendgreen"], count.index % 2)}-${local.hash_code}"
  resource_group_name = azurerm_resource_group.rg.name
  location          = var.location
  account_tier      = "Standard"
  account_replication_type = "LRS"
  
  # Enable blob public access
  allow_nested_items_to_be_public = true

  tags = {
    environment = element(["blue", "green"], count.index % 2)
  }
}