/*
   Variables for ECS_CLUSTER
*/


//variable "keypair_public_key" {}
variable "region" {}
variable "aws_key_name" {}
variable "bastion_sg_id" {}
#variable "vpc_sg_id" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "vpc_cidr" {}
variable "worker_instance_type" {}
variable "vpc-id" {}
variable "stack" {}
variable "environment" {}
variable "sns-arn" {}


variable "oc_worker_max_size" {
  default = 1
}

variable "oc_worker_min_size" {
  default = 1
}

variable "oc_worker_desired_size" {
  default = 1
}


variable "private_subnet_ids" {
   default = []
}

variable "dependency_id" {
  default = ""
}

variable "public_sub_cidr" {
     default = []
}

variable "private_sub_cidr" {
     default = []
}
