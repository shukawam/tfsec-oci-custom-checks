resource "oci_core_instance" "compute" {
  compartment_id      = var.compartment_ocid
  availability_domain = 1
  create_vnic_details {
    assign_public_ip = "true" # expected: OCI-00005, OCI-00014
  }
  # ... omit 
}
