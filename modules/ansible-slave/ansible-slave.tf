/*
  ansible_slave-node
  Nothing else apart from sshd to be on this node
*/

/* This is used to generate data about ami to be used */
data "aws_ami" "ansible_slave" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs*"]
  }

}


resource "aws_instance" "ansible_slave" {
    ami                         = "${"${data.aws_ami.ansible_slave.id}"}"
    instance_type               = "${var.ansible_slave_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.ansible-slave.id}"]
    #count                      = "${length(var.public_sub_cidr)}"
    user_data                   = "${data.template_file.userdata-ansible-slave.rendered}"
    subnet_id                   = "${var.pub_sub_id}"
    associate_public_ip_address = true
    source_dest_check           = false
    // Implicit dependency
    iam_instance_profile        = "${aws_iam_instance_profile.ansible_slave_profile.name}"

    tags = {
      Name        = "OC-ANSIBLE-NODE-${upper(var.stack)}-${upper(var.environment)}"
      Role        = "ansible_slave"
      Stack       = "OC"
    }

}
