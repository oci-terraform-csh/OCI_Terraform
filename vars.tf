/**
  *     These variables are obtained by running a shell script.
  *     They will have to be sourced each time a new terminal session
  *     is used. You could define them within another terraform file,
  *     but the file would still be specific to a user since it should
  *     not be committed to a repository or registry. For my use, the
  *     the bash script provided more flexibility.
  *     
  *     These variables will be called into "provider.tf".
  */

## Start of bash sourced variables ##
variable "tenancy_ocid" {}

variable "compartment_id" {}
variable "user_ocid" {}

variable "fingerprint" {}

variable "region" {}

variable "namespace" {}

variable "private_key_path" {}

variable "ssh_authorized_keys" {}

## End of bash sourced variables ##

## Start of variables that have been declared in the module's resource but undefined.

variable "AD" {
  default = "1"
}

variable "shape" {
  default = "VM.Standard2.2"
}

variable "display_name" {
  default = "test_instance"
}

variable "source_id" {
  /**
                  *     Defaulted to Oracle Linux 7.x. The image will
                  *     need to be sourced for the appropriate region.
                  */
  default = "ocid1.image.oc1.iad.aaaaaaaa2mnepqp7wn3ej2axm2nkoxwwcdwf7uc246tcltg4li67z6mktdiq"
}
