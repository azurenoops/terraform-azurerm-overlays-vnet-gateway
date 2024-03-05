# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------------
# Express Route Circuit
#---------------------------------------------------------------

resource "azurerm_express_route_circuit_peering" "vgw" {
  for_each = local.express_route_circuit_peerings

  express_route_circuit_name    = local.express_route_circuit_name
  peering_type                  = each.value.peering_type
  resource_group_name           = coalesce(each.value.resource_group_name, var.existing_virtual_network_resource_group_name)
  vlan_id                       = each.value.vlan_id
  ipv4_enabled                  = each.value.ipv4_enabled
  peer_asn                      = each.value.peer_asn
  primary_peer_address_prefix   = each.value.primary_peer_address_prefix
  route_filter_id               = each.value.route_filter_id
  secondary_peer_address_prefix = each.value.secondary_peer_address_prefix
  shared_key                    = each.value.shared_key

  dynamic "microsoft_peering_config" {
    for_each = each.value.microsoft_peering_config == null ? [] : ["MicrosoftPeeringConfig"]

    content {
      advertised_public_prefixes = each.value.microsoft_advertised_public_prefixes
      advertised_communities     = each.value.microsoft_advertised_communities
      customer_asn               = each.value.microsoft_customer_asn
      routing_registry_name      = each.value.microsoft_routing_registry_name
    }
  }
}
