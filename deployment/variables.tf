/*
   Variables for all modules
*/

// VPC
variable "region" {}
variable "vpc_cidr" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
//variable "keypair_public_key" {}
variable "vpc_name" {}


variable "ansible_ssh_user" {}
variable "control_cidr" {}
variable "proxy_cidr" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}


// Route53
variable "main_zone_id" {}
variable "public_domain_name" {}


// Declare classes of instances for each modules
variable "bastion_instance_type" {}
variable "master_instance_type" {}
variable "worker_instance_type" {}
variable "ansible_slave_instance_type" {}

variable "oc_master_min_size" {}
variable "oc_master_max_size" {}
variable "oc_master_desired_size" {}

variable "oc_worker_max_size" {}
variable "oc_worker_min_size" {}
variable "oc_worker_desired_size" {}

variable "stack" {}
variable "environment" {}

// Generic
variable "azs" {
    default = []
}


variable "public_sub_cidr" {
     default = []
}


variable "private_sub_cidr" {
     default = []
}
