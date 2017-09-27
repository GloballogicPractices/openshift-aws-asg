/********************************************************************************/
// Open-shift modules
/********************************************************************************/

/********************************************************************************/
// Use my terraform version :-)
// Use `terraform init`
terraform {
  required_version = ">= 0.10.5"
  backend "s3" {
  bucket     = "openshift-terraform-state"
  key        = "terraform-tfstate-openshift-np"
  region     = "us-east-1"
  encrypt    = "true"
  }
}
/********************************************************************************/

provider "aws" {
  region = "${var.region}"
}

/***********************************************************
VPC
***********************************************************/

module "vpc" {
   source                   = "../modules/vpc"
   azs                      = "${var.azs}"
   vpc_cidr                 = "${var.vpc_cidr}"
   public_sub_cidr          = "${var.public_sub_cidr}"
   private_sub_cidr         = "${var.private_sub_cidr}"
   enable_dns_hostnames     = true
   vpc_name                 = "${var.vpc_name}"
   stack                    = "${var.stack}"
   environment              = "${var.environment}"
}

/***********************************************************
Bastion & ansible-slave
***********************************************************/

module "bastion" {
   source                      = "../modules/bastion"
   public_sub_cidr             = "${var.public_sub_cidr}"
   vpc-id                      = "${module.vpc.vpc_id}"
   pub_sub_id                  = "${module.vpc.aws_pub_subnet_id[0]}"
   region                      = "${var.region}"
   bastion_instance_type       = "${var.bastion_instance_type}"
   aws_key_name                = "${var.aws_key_name}"
   control_cidr                = "${var.control_cidr}"
   vpc_cidr                    = "${var.vpc_cidr}"
   ami_owner_name              = "${var.ami_owner_name}"
   ami_name_regex              = "${var.ami_name_regex}"
   stack                       = "${var.stack}"
   environment                 = "${var.environment}"
 }


/*
 module "ansible-slave" {
    source                      = "../modules/ansible-slave"
    public_sub_cidr             = "${var.public_sub_cidr}"
    vpc-id                      = "${module.vpc.vpc_id}"
    pub_sub_id                  = "${module.vpc.aws_pub_subnet_id[1]}"
    region                      = "${var.region}"
    ansible_slave_instance_type = "${var.ansible_slave_instance_type}"
    aws_key_name                = "${var.aws_key_name}"
    control_cidr                = "${var.control_cidr}"
    vpc_cidr                    = "${var.vpc_cidr}"
    ami_owner_name              = "${var.ami_owner_name}"
    ami_name_regex              = "${var.ami_name_regex}"
    stack                       = "${var.stack}"
    environment                 = "${var.environment}"
  }
*/



/***********************************************************
SNS
***********************************************************/
  module "sns-lambda" {
     source       = "../modules/aws-sns-lambda"
     sns_name     = "oc-asg-sns-name-${var.stack}-${var.environment}"
     private_zone = "Z19P07UMMQVZPW"
     stack        = "${var.stack}"
     environment  = "${var.environment}"
   }


/***********************************************************
OC Master cluster
***********************************************************/


module "openshift-master" {
   source                   = "../modules/oc-master"
   public_subnet_ids        = "${module.vpc.aws_pub_subnet_id}"
   vpc-id                   = "${module.vpc.vpc_id}"
   region                   = "${var.region}"
   aws_key_name             = "${var.aws_key_name}"
   master_instance_type     = "${var.master_instance_type}"
   bastion_sg_id            = "${module.bastion.bastion-sg-id}"
   oc_master_max_size       = "${var.oc_master_max_size}"
   oc_master_min_size       = "${var.oc_master_min_size}"
   oc_master_desired_size   = "${var.oc_master_desired_size}"
   ami_owner_name           = "${var.ami_owner_name}"
   ami_name_regex           = "${var.ami_name_regex}"
   vpc_cidr                 = "${var.vpc_cidr}"
   stack                    = "${var.stack}"
   environment              = "${var.environment}"
}


/***********************************************************
OC Nodes cluster
***********************************************************/
module "openshift-workers" {
   source                   = "../modules/oc-workers"
   private_subnet_ids       = "${module.vpc.aws_pri_subnet_id}"
   vpc-id                   = "${module.vpc.vpc_id}"
   region                   = "${var.region}"
   aws_key_name             = "${var.aws_key_name}"
   worker_instance_type     = "${var.worker_instance_type}"
   bastion_sg_id            = "${module.bastion.bastion-sg-id}"
   oc_worker_max_size       = "${var.oc_worker_max_size}"
   oc_worker_min_size       = "${var.oc_worker_min_size}"
   oc_worker_desired_size   = "${var.oc_worker_desired_size}"
   ami_owner_name           = "${var.ami_owner_name}"
   ami_name_regex           = "${var.ami_name_regex}"
   vpc_cidr                 = "${var.vpc_cidr}"
   stack                    = "${var.stack}"
   environment              = "${var.environment}"
   sns-arn                  = "${module.sns-lambda.sns-arn}"
}
