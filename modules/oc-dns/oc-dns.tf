# Module to register instances in AWS sub domain

resource "aws_route53_record" "a-record" {
    zone_id = "${var.domain-id}"
    name = "node1.openshift.local"
    type = "A"
    ttl  = 300
    records = [
        "${aws_instance.node1.private_ip}"
    ]
}
