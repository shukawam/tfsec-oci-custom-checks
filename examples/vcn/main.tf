#####
# VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = local.vcn_cidr_block
  display_name   = var.vcn_display_name
}

#####
# Gateways
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.internet_gateway_display_name
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.nat_gateway_display_name
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.service_gateway_display_name
  services {
    service_id = local.all_services.id
  }
}

#####
# Route Tables
resource "oci_core_default_route_table" "public_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  compartment_id             = var.compartment_ocid
  display_name               = local.public_route_table_display_name
  route_rules {
    destination       = local.cidr_block_all
    destination_type  = local.destination_type_cidr
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.private_route_table_display_name
  route_rules {
    destination       = local.cidr_block_all
    destination_type  = local.destination_type_cidr
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
  route_rules {
    destination       = local.all_services.cidr_block
    destination_type  = local.destination_type_service
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
}

#####
# Security Lists
resource "oci_core_security_list" "k8s_api_endpoint_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.k8s_api_endpoint_security_list_display_name
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_all # OCI-00006
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_node_pool_subnet
    tcp_options {

      max = "6443"
      min = "6443"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_node_pool_subnet
    tcp_options {
      max = "12250"
      min = "12250"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_icmp
    source   = local.cidr_block_node_pool_subnet
    icmp_options {
      type = "3"
      code = "4"
    }
  }
  egress_security_rules {
    destination      = local.all_services.cidr_block
    protocol         = local.protocol_tcp
    destination_type = local.destination_type_service
    tcp_options {
      max = "443"
      min = "443"
    }
  }
  egress_security_rules {
    destination = local.cidr_block_node_pool_subnet
    protocol    = local.protocol_tcp
  }
  egress_security_rules {
    destination = local.cidr_block_node_pool_subnet
    protocol    = local.protocol_icmp
    icmp_options {
      type = "3"
      code = "4"
    }
  }
}

resource "oci_core_security_list" "node_pool_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.node_pool_security_list_display_name
  ingress_security_rules {
    protocol = local.protocol_all
    source   = local.cidr_block_node_pool_subnet
  }
  ingress_security_rules {
    protocol = local.protocol_icmp
    source   = local.cidr_block_k8s_api_endpoint_subnet
    icmp_options {
      type = "3"
      code = "4"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_k8s_api_endpoint_subnet
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_all
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "30805"
      min = "30805"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "10256"
      min = "10256"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "31346"
      min = "31346"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "31078"
      min = "31078"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "32734"
      min = "32734"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "30656"
      min = "30656"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "31480"
      min = "31480"
    }
  }
  ingress_security_rules {
    protocol = local.protocol_tcp
    source   = local.cidr_block_lb_subnet
    tcp_options {
      max = "30572"
      min = "30572"
    }
  }
  egress_security_rules {
    destination = local.cidr_block_node_pool_subnet
    protocol    = local.protocol_all
  }
  egress_security_rules {
    destination = local.cidr_block_k8s_api_endpoint_subnet
    protocol    = local.protocol_tcp
    tcp_options {
      max = "6443"
      min = "6443"
    }
  }
  egress_security_rules {
    destination = local.cidr_block_k8s_api_endpoint_subnet
    protocol    = local.protocol_tcp
    tcp_options {
      max = "12250"
      min = "12250"
    }
  }
  egress_security_rules {
    destination = local.cidr_block_k8s_api_endpoint_subnet
    protocol    = local.protocol_icmp
    icmp_options {
      type = "3"
      code = "4"
    }
  }
  egress_security_rules {
    destination = local.cidr_block_all
    protocol    = local.protocol_icmp
    icmp_options {
      type = "3"
      code = "4"
    }
  }
  egress_security_rules {
    destination      = local.all_services.cidr_block
    protocol         = local.protocol_tcp
    destination_type = local.destination_type_service
    tcp_options {
      max = "443"
      min = "443"
    }
  }
  egress_security_rules {
    destination = local.cidr_block_all
    protocol    = local.protocol_tcp
  }
}

resource "oci_core_security_list" "lb_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = local.lb_security_list_display_name
}

#####
# Subnets
resource "oci_core_subnet" "k8s_api_endpoint_regional_subnet" {
  cidr_block        = local.cidr_block_k8s_api_endpoint_subnet
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  security_list_ids = [oci_core_security_list.k8s_api_endpoint_security_list.id]
  display_name      = local.k8s_api_endpoint_regional_subnet_display_name
  route_table_id    = oci_core_vcn.vcn.default_route_table_id
}

resource "oci_core_subnet" "node_pool_regional_subnet" {
  cidr_block                 = local.cidr_block_node_pool_subnet
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn.id
  security_list_ids          = [oci_core_security_list.node_pool_security_list.id]
  display_name               = local.node_pool_regional_subnet_display_name
  route_table_id             = oci_core_vcn.vcn.default_route_table_id
  prohibit_public_ip_on_vnic = local.subnet_prohibit_public_ip_on_vnic
}

resource "oci_core_subnet" "lb_regional_subnet" {
  cidr_block        = local.cidr_block_lb_subnet
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  security_list_ids = [oci_core_security_list.lb_security_list.id]
  display_name      = local.lb_regional_subnet_display_name
  route_table_id    = oci_core_vcn.vcn.default_route_table_id
}

#####
# Route Table Attachment
resource "oci_core_route_table_attachment" "private_route_table_attachment" {
  subnet_id      = oci_core_subnet.node_pool_regional_subnet.id
  route_table_id = oci_core_route_table.private_route_table.id
}
