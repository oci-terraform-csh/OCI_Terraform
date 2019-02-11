# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

data "oci_core_vcns" "VCNs" {
  #Required
  compartment_id = "${var.compartment_id}"

  #Optional
  # display_name = "${var.vcn_display_name}"
  # state = "${var.vcn_state}"
}

data "oci_core_internet_gateways" "IGs" {
  #Required
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.createVCN.id}"

  #Optional
  # display_name = "${var.internet_gateway_display_name}"
  # state = "${var.internet_gateway_state}"
}

data "oci_core_route_tables" "RTs" {
  #Required
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.createVCN.id}"

  #Optional
  # display_name = "${var.route_table_display_name}"
  # state = "${var.route_table_state}"
}

data "oci_core_security_lists" "SLs" {
  #Required
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.createVCN.id}"

  #Optional
  # display_name = "${var.security_list_display_name}"
  # state = "${var.security_list_state}"
}

data "oci_core_subnet" "SUB" {
  #Required
  subnet_id = "${oci_core_subnet.test_subnet.id}"
}
