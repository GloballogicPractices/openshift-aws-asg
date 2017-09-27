/*
 Variables for deploying stack
--------------------------------
- ACM certificates have to pre-exist
*/

region            = "us-west-2"
vpc_name          = "OpenSift"
vpc_cidr          = "10.3.0.0/16"
proxy_cidr        = "10.3.*"

// choose stack for A/B roll outs
stack="a"
// choose between non-prod or prod [ np | prod ]
environment = "np"


# AZs are combintation of az length + subnet cidrs
public_sub_cidr   = ["10.3.0.0/24","10.3.1.0/24","10.3.3.0/24"]
private_sub_cidr  = ["10.3.4.0/24","10.3.5.0/24","10.3.6.0/24"]
azs               = ["us-west-2a","us-west-2b","us-west-2c"]

bastion_instance_type       = "t2.small"
ansible_slave_instance_type = "t2.medium"
master_instance_type        = "t2.large"
worker_instance_type        = "t2.large"

# Ansible auto ssh
ansible_ssh_user  = "ec2-user"
ansible_user      = "ansible"

// For public facing sites and ELBs
control_cidr = "202.174.0.0/32,139.5.0.0/16,34.193.0.0/16,115.249.0.0/16,159.182.0.0/16,42.111.0.0/16,192.251.0.0/16,54.82.34.148/32,27.50.0.0/16,52.14.5.155/32,223.176.0.0/16,34.207.47.108/32,52.89.89.192/32,162.222.72.0/21,66.85.48.0/21,54.196.127.227/32,49.207.0.0/16,106.202.0.0/16"

// ASG Size
# Couch-master
oc_master_max_size     = 3
oc_master_min_size     = 1
oc_master_desired_size = 1

oc_worker_max_size     = 5
oc_worker_min_size     = 3
oc_worker_desired_size = 3


// Route53
main_zone_id       = "ZP2PBKSIVYYY5"
public_domain_name = "oc.gl-poc.com"

//RHEL-AMI
# ami_owner_name   = OwnerId
ami_owner_name   = "410186602215"
ami_name_regex   = "CentOS Linux 7 x86_64 *"
