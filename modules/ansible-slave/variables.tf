/*
   Variables for bastion
*/

variable "vpc-id" {}
variable "region" {}
variable "pub_sub_id" {}
variable "aws_key_name" {}
#variable "iam_role" {}
#variable "ansible_ssh_user" {}
#variable "proxy_cidr" {}
#variable "bastion_instance_type" {}
variable "ansible_slave_instance_type" {}
variable "vpc_cidr" {}
variable "stack" {}
variable "environment" {}


variable "ami_owner_name" {}
variable "ami_name_regex" {}

variable "dependency_id" {
  default = ""
}

variable "public_sub_cidr" {
     default = []
}

variable "control_cidr" {
}
