output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "aws_pub_subnet_id" {
  value = ["${aws_subnet.public-subnet.*.id}"]
}

output "aws_pri_subnet_id" {
  value = ["${aws_subnet.private-subnet.*.id}"]
}

// str ouput values can be used by split functions
// to be used in other resources
output "aws_pri_subnet_id_str" {
  value = "${join(",",aws_subnet.private-subnet.*.id)}"
}

output "aws_pub_subnet_id_str" {
  value = "${join(",",aws_subnet.public-subnet.*.id)}"
}

// output for RDS DB-Subnet group
output "aws_pri_subnet_id_1" {
  value = "${aws_subnet.private-subnet.1.id}"
}
output "aws_pri_subnet_id_0" {
  value = "${aws_subnet.private-subnet.0.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}
