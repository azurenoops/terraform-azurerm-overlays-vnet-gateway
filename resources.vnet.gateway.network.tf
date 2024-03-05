# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------------
# Virtual Network Gateway network
#---------------------------------------------------------------

resource "azurerm_subnet" "vgw" {
  count = var.existing_gateway_subnet_id != "" ? 0 : 1

  address_prefixes     = [var.gateway_subnet_address_prefix]
  name                 = "GatewaySubnet"
  resource_group_name  = var.existing_virtual_network_resource_group_name != "" ? var.existing_virtual_network_resource_group_name : local.resource_group_name
  virtual_network_name = var.existing_virtual_network_name
}

resource "azurerm_route_table" "vgw" {
  count = var.enable_route_table_creation ? 1 : 0

  location                      = var.location
  name                          = coalesce(var.route_table_name, "${local.virtual_network_gateway_name}-rt")
  resource_group_name           = try(local.resource_group_name, var.existing_virtual_network_resource_group_name)
  disable_bgp_route_propagation = !var.enable_route_table_bgp_route_propagation
  tags = local.default_tags
}

resource "azurerm_subnet_route_table_association" "vgw" {
  count = var.enable_route_table_creation ? 1 : 0

  route_table_id = azurerm_route_table.vgw[0].id
  subnet_id      = try(azurerm_subnet.vgw[0].id, var.existing_gateway_subnet_id)

  depends_on = [
    azurerm_subnet.vgw,
    azurerm_route_table.vgw
  ]
}

resource "azurerm_public_ip" "vgw" {
  for_each = local.ip_configurations

  allocation_method   = each.value.public_ip.allocation_method
  location            = var.location
  name                = coalesce(each.value.public_ip.name, "${local.virtual_network_gateway_name}-${each.key}-pip")
  resource_group_name = try(local.resource_group_name, var.existing_virtual_network_resource_group_name)
  sku                 = each.value.public_ip.sku
  tags = local.default_tags
}
