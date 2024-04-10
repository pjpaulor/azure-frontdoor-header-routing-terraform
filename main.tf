# Provider configuration
provider "azurerm" {
  features {}
}

# Generate random names
resource "random_pet" "random_names" {
  length    = 2
  separator = "-"
}

# Generate hash codes for resource names
locals {
  hash_code = substr(sha1(random_pet.random_names.*.id), 0, 5)
}

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg--${local.hash_code}"
  location = "West Europe"
}
