resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id = var.compartment_ocid
  display_name   = "test"
  shape          = "flexible"
  subnet_ids     = var.subnet_ids
  is_private     = "false"
}
