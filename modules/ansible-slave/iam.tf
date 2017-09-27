resource "aws_iam_role" "ansible_slave_role" {
  name = "ansible_slave_role-oc-${var.stack}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/* Profile is how we attach role to instances */
resource "aws_iam_instance_profile" "ansible_slave_profile" {
  name  = "ansible_slave_profile-oc-${var.stack}-${var.environment}"
  role  = "${aws_iam_role.ansible_slave_role.name}"
}


resource "aws_iam_role_policy" "ansible_slave_policy" {
  name = "ansible_slave_policy-oc-${var.stack}-${var.environment}"
  role = "${aws_iam_role.ansible_slave_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:Describe*",
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "autoscaling:Describe*",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
