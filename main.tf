module "createVCN" {
  source         = "./OCI_Virtual_Cloud_Network_Module"
  compartment_id = "${var.compartment_id}"
}

resource "oci_core_internet_gateway" "test_ig" {
  compartment_id = "${var.compartment_id}"
  display_name   = "${var.display_name}"
  vcn_id         = "${module.createVCN.id}"
}

resource "oci_core_route_table" "test_rt" {
  compartment_id = "${var.compartment_id}"
  vcn_id         = "${module.createVCN.id}"
  display_name   = "${var.display_name}"

  route_rules {
    destination       = "0.0.0.0/16"
    network_entity_id = "${oci_core_internet_gateway.test_ig.id}"
  }
}

resource "oci_core_security_list" "test_seclist" {
  compartment_id = "${var.compartment_id}"

  vcn_id = "${module.createVCN.id}"

  display_name = "${var.display_name}"

  egress_security_rules = [
    {
      destination = "0.0.0.0/0"
      protocol    = "6"
    },
  ]

  ingress_security_rules = [
    {
      tcp_options {
        "max" = 22
        "min" = 22
      }

      protocol = "6"

      source = "0.0.0.0/0"
    },
    {
      tcp_options {
        "max" = 3389
        "min" = 3389
      }

      protocol = "6"

      source = "0.0.0.0/0"
    },
  ]
}

resource "oci_core_subnet" "test_subnet" {
  #Required
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  cidr_block          = "10.0.0.0/24"
  compartment_id      = "${var.compartment_id}"
  security_list_ids   = ["${oci_core_security_list.test_seclist.id}"]
  vcn_id              = "${module.createVCN.id}"

  #Optional
  # defined_tags = {"Operations.CostCenter"= "42"}
  # dhcp_options_id = "${oci_core_dhcp_options.test_dhcp_options.id}"
  # display_name = "${var.subnet_display_name}"
  # dns_label = "${var.subnet_dns_label}"
  # freeform_tags = {"Department"= "Finance"}
  # prohibit_public_ip_on_vnic = "${var.subnet_prohibit_public_ip_on_vnic}"
  # route_table_id = "${oci_core_route_table.test_route_table.id}"
}

module "createInstance" {
  /** 
  *  If you don't directly define a key/value here, you will need
  *  to source it from the vars.tf file located in the root folder.
  *  If the value has a default from it's parent vars.tf file, the 
  *  entire field can be omitted from the module.
  */
  source = "./OCI_Instance_Module/"

  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id      = "${var.compartment_id}"
  shape               = "${var.shape}"
  subnet_id           = "${oci_core_subnet.test_subnet.id}"
  display_name        = "${var.display_name}"
  source_id           = "${var.source_id}"
  ssh_authorized_keys = "${var.ssh_authorized_keys}"
}
