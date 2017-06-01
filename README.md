# tf-vlan-404-example

An example to reproduce https://github.com/IBM-Bluemix/terraform/issues/133

Simply execute in this order:

- `terraform plan`
- `terraform apply`
  ```
  terraform apply
  ibmcloud_infra_vlan.public_vlan: Creating...
    child_resource_count: "" => "<computed>"
    datacenter:           "" => "dal12"
    name:                 "" => "test"
    router_hostname:      "" => "<computed>"
    softlayer_managed:    "" => "<computed>"
    subnet_size:          "" => "16"
    subnets.#:            "" => "<computed>"
    type:                 "" => "PUBLIC"
    vlan_number:          "" => "<computed>"
  ibmcloud_infra_vlan.public_vlan: Still creating... (10s elapsed)
  ibmcloud_infra_vlan.public_vlan: Still creating... (20s elapsed)
  ibmcloud_infra_vlan.public_vlan: Still creating... (30s elapsed)
  ibmcloud_infra_vlan.public_vlan: Creation complete (ID: 1850387)

  Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
  ```
- Delete the VLAN via SL https://control.bluemix.net/network/vlans
  - *note: this can take quite some time, I've experienced as long as 24 hours*
    - If you don't want to wait, you can modify the id in the `terraform.tfstate`
    file, modifying the `ibmcloud_infra_vlan.public_vlan` => `primary` => `id`
    value, an example below:
      ```
      "resources": {
        "ibmcloud_infra_vlan.public_vlan": {
            "type": "ibmcloud_infra_vlan",
            "depends_on": [],
            "primary": {
                "id": "1850387", # <== this value
      ```
- Run `terraform plan` - should result in 404 error:
  ```
  Refreshing Terraform state in-memory prior to plan...
  The refreshed state will be used to calculate this plan, but will not be
  persisted to local or remote state storage.

  ibmcloud_infra_vlan.public_vlan: Refreshing state... (ID: 1850387)
  Error refreshing state: 1 error(s) occurred:

  * ibmcloud_infra_vlan.public_vlan: ibmcloud_infra_vlan.public_vlan: SoftLayer_Exception_ObjectNotFound: Unable to find object with id of '1850387'. (HTTP 404)
  ```
