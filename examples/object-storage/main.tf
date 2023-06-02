resource "oci_objectstorage_bucket" "object-storage-1" {
  compartment_id = var.compartment_ocid
  name           = var.object_storage_bucket_name
  namespace      = var.object_storage_namespace
  access_type    = "ObjectRead" # OCI-00002
}

resource "oci_objectstorage_bucket" "object-storage-1" {
  compartment_id = var.compartment_ocid
  name           = var.object_storage_bucket_name
  namespace      = var.object_storage_namespace
  access_type    = "ObjectReadWithoutList" # OCI-00002
}

resource "oci_objectstorage_bucket" "object-storage-1" {
  compartment_id = var.compartment_ocid
  name           = var.object_storage_bucket_name
  namespace      = var.object_storage_namespace
}
