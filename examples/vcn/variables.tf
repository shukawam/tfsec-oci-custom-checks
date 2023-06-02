#####
# Provider
variable "region" {
  description = "OCI Region Identifier. (e.g. ap-tokyo-1, ...)"
}

variable "tenancy_ocid" {
  description = "OCID of tenancy."
}

variable "user_ocid" {
  description = "OCID of user."
}

variable "private_key_path" {
  default     = null
  description = "File path of private key."
}

variable "private_key" {
  default     = null
  description = "Content of private key."
}

variable "fingerprint" {
  description = "Fingerprint."
}

variable "compartment_ocid" {
  description = "OCID of compartment."
}

#####
# VCN
variable "vcn_display_name" {
  description = "VCN display name"
}
