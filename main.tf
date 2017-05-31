terraform {
  required_version = ">= 0.9.3"
}

provider "ibmcloud" {}

resource "ibmcloud_infra_vlan" "public_vlan" {
   name = "test"
   datacenter = "dal12"
   type = "PUBLIC"
   subnet_size = 16
}
