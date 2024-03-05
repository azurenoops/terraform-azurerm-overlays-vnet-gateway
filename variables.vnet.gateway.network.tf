# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
# Global Configuration   ##
###########################

variable "sku" {
  type        = string
  description = "The SKU (size) of the Virtual Network Gateway."

  validation {
    condition     = contains(["Basic", "HighPerformance", "Standard", "UltraPerformance", "VpnGw1", "VpnGw2", "VpnGw3", "VpnGw4", "VpnGw5", "VpnGw1AZ", "VpnGw2AZ", "VpnGw3AZ", "VpnGw4AZ", "VpnGw5AZ", "ErGw1AZ", "ErGw2AZ", "ErGw3AZ"], var.sku)
    error_message = "sku possible values are Basic, HighPerformance, Standard, UltraPerformance, VpnGw1, VpnGw2, VpnGw3, VpnGw4, VpnGw5, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ, VpnGw4AZ, VpnGw5AZ, ErGw1AZ, ErGw2AZ, ErGw3AZ."
  }
}

variable "type" {
  type        = string
  description = "The type of the Virtual Network Gateway, ExpressRoute or VPN."

  validation {
    condition     = contains(["ExpressRoute", "Vpn"], var.type)
    error_message = "type possible values are ExpressRoute or VPN."
  }
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "The availability zone of the Virtual Network Gateway. Only supported for AZ SKUs."
}

variable "enable_vpn_active_active" {
  type        = bool
  default     = false
  description = "Enable active-active mode for the Virtual Network Gateway."
  nullable    = false
}

variable "enable_vpn_bgp" {
  type        = bool
  default     = false
  description = "Enable BGP for the Virtual Network Gateway."
  nullable    = false
}

variable "vpn_bgp_settings" {
  type = object({
    asn         = optional(number, null)
    peer_weight = optional(number, null)
  })
  default     = null
  description = "BGP settings for the Virtual Network Gateway."
}

variable "vpn_generation" {
  type        = string
  default     = null
  description = "value for the Generation for the Gateway, Valid values are 'Generation1', 'Generation2'. Options differ depending on SKU."

  validation {
    condition     = var.vpn_generation == null ? true : contains(["Generation1", "Generation2"], var.vpn_generation)
    error_message = "vpn_generation possible values are 'Generation1', 'Generation2'. Options differ depending on SKU."
  }
}

variable "enable_vpn_private_ip_address" {
  type        = bool
  default     = null
  description = "Enable private IP address for the Virtual Network Gateway for Virtual Network Gateway Connections. Only supported for AZ SKUs."
}

variable "vpn_type" {
  type        = string
  default     = "RouteBased"
  description = "The VPN type of the Virtual Network Gateway."
  nullable    = false

  validation {
    condition     = contains(["PolicyBased", "RouteBased"], var.vpn_type)
    error_message = "vpn_type possible values are PolicyBased or RouteBased."
  }
}

variable "ip_configurations" {
  type = map(object({
    ip_configuration_name         = optional(string, null)
    apipa_addresses               = optional(list(string), null)
    private_ip_address_allocation = optional(string, "Dynamic")
    public_ip = optional(object({
      name              = optional(string, null)
      allocation_method = optional(string, "Dynamic")
      sku               = optional(string, "Basic")
      tags              = optional(map(string), {})
    }), {})
  }))
  default     = {}
  description = <<DESCRIPTION
Map of IP Configurations to create for the Virtual Network Gateway.

- `ip_configuration_name` - (Optional) The name of the IP Configuration.
- `apipa_addresses` - (Optional) The list of APPIPA addresses.
- `private_ip_address_allocation` - (Optional) The private IP allocation method. Possible values are Static or Dynamic. Defaults to Dynamic.
- `public_ip` - (Optional) a `public_ip` block as defined below. Used to configure the Public IP Address for the IP Configuration.
  - `name` - (Optional) The name of the Public IP Address.
  - `allocation_method` - (Optional) The allocation method of the Public IP Address. Possible values are Static or Dynamic. Defaults to Dynamic.
  - `sku` - (Optional) The SKU of the Public IP Address. Possible values are Basic or Standard. Defaults to Basic.
  - `tags` - (Optional) A mapping of tags to assign to the resource.
DESCRIPTION
  nullable    = false
}

variable "vpn_point_to_site" {
  type = object({
    address_space         = list(string)
    aad_tenant            = optional(string, null)
    aad_audience          = optional(string, null)
    aad_issuer            = optional(string, null)
    radius_server_address = optional(string, null)
    radius_server_secret  = optional(string, null)
    root_certificate = optional(map(object({
      name             = string
      public_cert_data = string
    })), {})
    revoked_certificate = optional(map(object({
      name       = string
      thumbprint = string
    })), {})
    vpn_client_protocols = optional(list(string), null)
    vpn_auth_types       = optional(list(string), null)
  })
  default     = null
  description = <<DESCRIPTION
Point to site configuration for the virtual network gateway.

- `address_space` - (Required) Address space for the virtual network gateway.
- `aad_tenant` - (Optional) The AAD tenant to use for authentication.
- `aad_audience` - (Optional) The AAD audience to use for authentication.
- `aad_issuer` - (Optional) The AAD issuer to use for authentication.
- `radius_server_address` - (Optional) The address of the radius server.
- `radius_server_secret` - (Optional) The secret of the radius server.
- `root_certificate` - (Optional) The root certificate of the virtual network gateway.
  - `name` - (Required) The name of the root certificate.
  - `public_cert_data` - (Required) The public certificate data.
- `revoked_certificate` - (Optional) The revoked certificate of the virtual network gateway.
  - `name` - (Required) The name of the revoked certificate.
  - `thumbprint` - (Required) The thumbprint of the revoked certificate.
- `vpn_client_protocols` - (Optional) The VPN client protocols.
- `vpn_auth_types` - (Optional) The VPN authentication types.
DESCRIPTION
}

#####################################
# Existing Network Configuration   ##
#####################################

variable "existing_virtual_network_name" {
  type        = string
  description = "The name of the Existing Virtual Network."
}

variable "existing_virtual_network_resource_group_name" {
  type        = string
  description = "The name of the Existing Virtual Network's Resource Group. If not specified, the module created resourxe group will be used."
  default = null
}

variable "enable_route_table_bgp_route_propagation" {
  type        = bool
  default     = true
  description = "Whether or not to enable BGP route propagation on the Route Table."
  nullable    = false
}

variable "enable_route_table_creation" {
  type        = bool
  default     = false
  description = "Whether or not to create a Route Table associated with the Virtual Network Gateway Subnet."
  nullable    = false
}

variable "route_table_name" {
  type        = string
  default     = null
  description = "Name of the Route Table associated with Virtual Network Gateway Subnet."
}

variable "route_table_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the Route Table."
  nullable    = false
}

variable "gateway_subnet_address_prefix" {
  type        = string
  default     = ""
  description = "The address prefix for the gateway subnet. Either subnet_id or subnet_address_prefix must be specified."
  nullable    = false
}

variable "existing_gateway_subnet_id" {
  type        = string
  default     = ""
  description = "The ID of a pre-existing gateway subnet to use for the Virtual Network Gateway. Either subnet_id or subnet_address_prefix must be specified."
  nullable    = false
}




