/*
- applications-worker-sg
- All traffic in vpc is open since we do not know what all ports we may
  have to open
 */
resource "aws_security_group" "worker-sg" {
   name = "worker-sg-${var.stack}-${var.environment}"
   vpc_id = "${var.vpc-id}"

   // allows traffic from the SG itself for tcp
   ingress {
       from_port = 0
       to_port = 65535
       protocol = "tcp"
       self = true
   }

   // allows traffic from the SG itself for udp
   ingress {
       from_port = 0
       to_port = 65535
       protocol = "udp"
       self = true
   }

   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       security_groups = ["${var.bastion_sg_id}"]
   }

   ingress {
      from_port = 0
      to_port = 65535
      protocol = "udp"
      cidr_blocks = ["${var.vpc_cidr}"]
   }

   ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
   }


   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }
}
