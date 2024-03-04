# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_example" {
  #source  = "azurenoops/overlays-example/azurerm"
  #version = "x.x.x"
  source = "../../.."

  # Resource Group, location, VNet and Subnet details
  create_resource_group = true
  location              = var.location
  deploy_environment    = var.deploy_environment
  environment           = var.environment
  org_name              = var.org_name
  workload_name         = var.workload_name

  #echo_text = "Hello, world!"
}
