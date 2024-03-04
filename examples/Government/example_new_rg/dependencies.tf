# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

 resource "azurerm_resource_group" "example-network-rg" {
  name     = "example-network-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "example-vnet" {
  depends_on = [
    azurerm_resource_group.example-network-rg
  ]
  name                = "example-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.example-network-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "example-snet" {
  depends_on = [
    azurerm_resource_group.example-network-rg,
    azurerm_virtual_network.example-vnet
  ]
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example-network-rg.name
  virtual_network_name = azurerm_virtual_network.example-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "example-nsg" {
  depends_on = [
    azurerm_resource_group.example-network-rg,
  ]
  name                = "example-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.example-network-rg.name
  tags = {
    environment = "test"
  }
}

resource "azurerm_log_analytics_workspace" "example-log" {
  depends_on = [
    azurerm_resource_group.example-network-rg
  ]
  name                = "example-log"
  location            = var.location
  resource_group_name = azurerm_resource_group.example-network-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    environment = "test"
  }
}
