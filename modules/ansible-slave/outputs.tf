output "ansible-slave-sg-id" {
   value = "${aws_security_group.ansible-slave.id}"
}

output "ip_authorised_for_inbound_traffic" {
   value = "${var.control_cidr}"
}
