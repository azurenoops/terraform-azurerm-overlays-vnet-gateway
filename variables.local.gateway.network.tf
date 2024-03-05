# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
# Global Configuration   ##
###########################

variable "local_network_gateways" {
  type = map(object({
    id              = optional(string, null)
    name            = optional(string, null)
    address_space   = optional(list(string), null)
    gateway_fqdn    = optional(string, null)
    gateway_address = optional(string, null)
    tags            = optional(map(string), {})
    bgp_settings = optional(object({
      asn                 = number
      bgp_peering_address = string
      peer_weight         = optional(number, null)
    }), null)
    connection = optional(object({
      name                               = optional(string, null)
      type                               = string
      connection_mode                    = optional(string, null)
      connection_protocol                = optional(string, null)
      dpd_timeout_seconds                = optional(number, null)
      egress_nat_rule_ids                = optional(list(string), null)
      enable_bgp                         = optional(bool, null)
      ingress_nat_rule_ids               = optional(list(string), null)
      local_azure_ip_address_enabled     = optional(bool, null)
      peer_virtual_network_gateway_id    = optional(string, null)
      routing_weight                     = optional(number, null)
      shared_key                         = optional(string, null)
      tags                               = optional(map(string), null)
      use_policy_based_traffic_selectors = optional(bool, null)
      custom_bgp_addresses = optional(object({
        primary   = string
        secondary = string
      }), null)
      ipsec_policy = optional(object({
        dh_group         = string
        ike_encryption   = string
        ike_integrity    = string
        ipsec_encryption = string
        ipsec_integrity  = string
        pfs_group        = string
        sa_datasize      = optional(number, null)
        sa_lifetime      = optional(number, null)
      }), null)
      traffic_selector_policy = optional(list(
        object({
          local_address_prefixes  = list(string)
          remote_address_prefixes = list(string)
        })
      ), null)
    }), null)
  }))
  default     = {}
  description = <<DESCRIPTION
Map of Local Network Gateways and Virtual Network Gateway Connections to create for the Virtual Network Gateway.

- `id` - (Optional) The ID of the pre-exisitng Local Network Gateway.
- `name` - (Optional) The name of the Local Network Gateway to create.
- `address_space` - (Optional) The list of address spaces for the Local Network Gateway.
- `gateway_fqdn` - (Optional) The gateway FQDN for the Local Network Gateway.
- `gateway_address` - (Optional) The gateway IP address for the Local Network Gateway.
- `tags` - (Optional) A mapping of tags to assign to the resource.
- `bgp_settings` - (Optional) a `bgp_settings` block as defined below. Used to configure the BGP settings for the Local Network Gateway.
  - `asn` - (Required) The ASN of the Local Network Gateway.
  - `bgp_peering_address` - (Required) The BGP peering address of the Local Network Gateway.
  - `peer_weight` - (Optional) The weight added to routes learned from this BGP speaker.

- `connection` - (Optional) a `connection` block as defined below. Used to configure the Virtual Network Gateway Connection for the Local Network Gateway.
  - `name` - (Optional) The name of the Virtual Network Gateway Connection.
  - `type` - (Required) The type of Virtual Network Gateway Connection. Possible values are IPsec or Vnet2Vnet.
  - `connection_mode` - (Optional) The connection mode.
  - `connection_protocol` - (Optional) The connection protocol. Possible values are IKEv2 or IKEv1.
  - `dpd_timeout_seconds` - (Optional) The dead peer detection timeout in seconds.
  - `egress_nat_rule_ids` - (Optional) The list of egress NAT rule IDs.
  - `enable_bgp` - (Optional) Whether or not BGP is enabled for this Virtual Network Gateway Connection.
  - `ingress_nat_rule_ids` - (Optional) The list of ingress NAT rule IDs.
  - `local_azure_ip_address_enabled` - (Optional) Whether or not the local Azure IP address is enabled.
  - `peer_virtual_network_gateway_id` - (Optional) The ID of the peer Virtual Network Gateway.
  - `routing_weight` - (Optional) The routing weight.
  - `shared_key` - (Optional) The shared key.
  - `tags` - (Optional) A mapping of tags to assign to the resource.
  - `use_policy_based_traffic_selectors` - (Optional) Whether or not to use policy based traffic selectors.
  - `custom_bgp_addresses` - (Optional) a `custom_bgp_addresses` block as defined below. Used to configure the custom BGP addresses for the Virtual Network Gateway Connection.
    - `primary` - (Required) The primary custom BGP address.
    - `secondary` - (Required) The secondary custom BGP address.
  - `ipsec_policy` - (Optional) a `ipsec_policy` block as defined below. Used to configure the IPsec policy for the Virtual Network Gateway Connection.
    - `dh_group` - (Required) The DH Group used in IKE Phase 1 for initial SA.
    - `ike_encryption` - (Required) The IKE encryption algorithm (IKE phase 2).
    - `ike_integrity` - (Required) The IKE integrity algorithm (IKE phase 2).
    - `ipsec_encryption` - (Required) The IPSec encryption algorithm (IKE phase 1).
    - `ipsec_integrity` - (Required) The IPSec integrity algorithm (IKE phase 1).
    - `pfs_group` - (Required) The Pfs Group used in IKE Phase 2 for new child SA.
    - `sa_datasize` - (Optional) The IPSec Security Association (also called Quick Mode or Phase 2 SA) data size specified in KB for a policy.
    - `sa_lifetime` - (Optional) The IPSec Security Association (also called Quick Mode or Phase 2 SA) lifetime specified in seconds for a policy.
  - `traffic_selector_policy` - (Optional) a `traffic_selector_policy` block as defined below. Used to configure the traffic selector policy for the Virtual Network Gateway Connection.
    - `local_address_prefixes` - (Required) The list of local address prefixes.
    - `remote_address_prefixes` - (Required) The list of remote address prefixes.
  DESCRIPTION
  nullable    = false

  validation {
    condition     = var.local_network_gateways == null ? true : alltrue([for k, v in var.local_network_gateways : (v.gateway_fqdn == null && v.gateway_address == null ? false : true) if v.id == null])
    error_message = "At least one of gateway_fqdn or gateway_address must be specified for local_network_gateways."
  }
}