# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

 resource "azurerm_resource_group" "vng-network-rg" {
  name     = "vng-network-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "vng-vnet" {
  depends_on = [
    azurerm_resource_group.vng-network-rg
  ]
  name                = "vng-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.vng-network-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "vng-snet" {
  depends_on = [
    azurerm_resource_group.vng-network-rg,
    azurerm_virtual_network.vng-vnet
  ]
  name                 = "vng-subnet"
  resource_group_name  = azurerm_resource_group.vng-network-rg.name
  virtual_network_name = azurerm_virtual_network.vng-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "vng-nsg" {
  depends_on = [
    azurerm_resource_group.vng-network-rg,
  ]
  name                = "vng-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.vng-network-rg.name
  tags = {
    environment = "test"
  }
}

resource "azurerm_log_analytics_workspace" "vng-log" {
  depends_on = [
    azurerm_resource_group.vng-network-rg
  ]
  name                = "vng-log"
  location            = var.location
  resource_group_name = azurerm_resource_group.vng-network-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    environment = "test"
  }
}
