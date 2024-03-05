# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################
# Express Route Configuration   ##
##################################

variable "express_route_circuits" {
  type = map(object({
    id                  = string
    resource_group_name = optional(string, null)
    connection = optional(object({
      authorization_key            = optional(string, null)
      express_route_gateway_bypass = optional(bool, null)
      name                         = optional(string, null)
      routing_weight               = optional(number, null)
      shared_key                   = optional(string, null)
      tags                         = optional(map(string), {})
    }), null)
    peering = optional(object({
      peering_type                  = string
      vlan_id                       = number
      ipv4_enabled                  = optional(bool, true)
      peer_asn                      = optional(number, null)
      primary_peer_address_prefix   = optional(string, null)
      secondary_peer_address_prefix = optional(string, null)
      shared_key                    = optional(string, null)
      route_filter_id               = optional(string, null)
      microsoft_peering_config = optional(object({
        advertised_public_prefixes = list(string)
        advertised_communities     = optional(list(string), null)
        customer_asn               = optional(number, null)
        routing_registry_name      = optional(string, null)
      }), null)
    }), null)
  }))
  default     = {}
  description = <<DESCRIPTION
Map of Virtual Network Gateway Connections and Peering Configurations to create for existing ExpressRoute circuits.

- `id` - (Required) The ID of the ExpressRoute circuit.

- `connection` - (Optional) a `connection` block as defined below. Used to configure the Virtual Network Gateway Connection between the ExpressRoute Circuit and the Virtual Network Gateway.
  - `authorization_key` - (Optional) The authorization key for the ExpressRoute Circuit.
  - `express_route_gateway_bypass` - (Optional) Whether to bypass the ExpressRoute Gateway for data forwarding.
  - `name` - (Optional) The name of the Virtual Network Gateway Connection.
  - `routing_weight` - (Optional) The weight added to routes learned from this Virtual Network Gateway Connection. Defaults to 10.
  - `shared_key` - (Optional) The shared key for the Virtual Network Gateway Connection.
  - `tags` - (Optional) A mapping of tags to assign to the resource.

- `peering` - (Optional) a `peering` block as defined below. Used to configure the ExpressRoute Circuit Peering.
  - `peering_type` - (Required) The type of the peering. Possible values are AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering.
  - `vlan_id` - (Required) The VLAN ID for the peering.
  - `ipv4_enabled` - (Optional) Whether IPv4 is enabled on the peering. Defaults to true.
  - `peer_asn` - (Optional) The peer ASN.
  - `primary_peer_address_prefix` - (Optional) The primary address prefix.
  - `secondary_peer_address_prefix` - (Optional) The secondary address prefix.
  - `shared_key` - (Optional) The shared key for the peering.
  - `route_filter_id` - (Optional) The ID of the route filter to apply to the peering.
  - `microsoft_peering_config` - (Optional) a `microsoft_peering_config` block as defined below. Used to configure the Microsoft Peering.
    - `advertised_communities` - (Optional) The list of communities to advertise to the Microsoft Peering.
    - `advertised_public_prefixes` - (Required) The list of public prefixes to advertise to the Microsoft Peering.
    - `customer_asn` - (Optional) The customer ASN.
    - `routing_registry_name` - (Optional) The routing registry name.
DESCRIPTION
  nullable    = false

  validation {
    condition     = var.express_route_circuits == null ? true : alltrue([for k, v in var.express_route_circuits : contains(["AzurePrivatePeering", "AzurePublicPeering", "MicrosoftPeering"], v.peering.peering_type) if v.peering != null])
    error_message = "peering_type possible values are AzurePrivatePeering, AzurePublicPeering or MicrosoftPeering."
  }
}