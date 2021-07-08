resource "null_resource" "test" {
    provisioner "local-exec" {
    command = "echo $IC_IAM_TOKEN ********** $IC_IAM_REFRESH_TOKEN"
    }
}

provider "ibm" {
  #ibmcloud_api_key      = var.api_key
  generation            = var.generation
  region                = "us-east"
  ibmcloud_timeout      = 300
}

variable "generation" {
  default     = 2
  description = "The VPC Generation to target. Valid values are 2 or 1."
}

variable "TF_VERSION" {
 default = "0.12"
 description = "terraform engine version to be used in schematics"
}

//security group
resource "ibm_is_security_group" "vnf_security_group" {
  name           = "mysggrp"
  vpc            = "r014-25616dea-4d43-45f8-b2ca-74d871154406"
}

//security group rule to allow ssh all for management
resource "ibm_is_security_group_rule" "vnf_sg_allow_ssh" {
  depends_on = [ibm_is_security_group.vnf_security_group]
  group     = ibm_is_security_group.vnf_security_group.id
  direction = "inbound"
  remote     = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

//security group rule to allow https all for management
resource "ibm_is_security_group_rule" "vnf_sg_rule_in_all" {
  depends_on = [ibm_is_security_group_rule.vnf_sg_allow_ssh]
  group     = ibm_is_security_group.vnf_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}