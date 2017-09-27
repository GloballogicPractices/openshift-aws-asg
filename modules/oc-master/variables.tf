/*
   Variables for ECS_CLUSTER
*/


variable "region" {}
variable "aws_key_name" {}
variable "bastion_sg_id" {}
variable "vpc-id" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "vpc_cidr" {}
variable "master_instance_type" {}
variable "stack" {}
variable "environment" {}

variable "public_subnet_ids" {
  default = []
}
variable "oc_master_max_size" {
  default = 1
}

variable "oc_master_min_size" {
  default = 1
}

variable "oc_master_desired_size" {
  default = 1
}




variable "dependency_id" {
  default = ""
}
