resource "aws_iam_role" "sns_role" {
  name = "role-oc-sns-${var.stack}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/* Profile is how we attach role to instances */
resource "aws_iam_instance_profile" "sns_profile" {
  name  = "profile-oc-sns-${var.stack}-${var.environment}"
  role = "${aws_iam_role.sns_role.name}"
}


resource "aws_iam_role_policy" "sns_policy" {
  name = "policy-oc-sns-${var.stack}-${var.environment}"
  role = "${aws_iam_role.sns_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "SNS:*"
      ],
      "Resource": "*"
    }

  ]
}
EOF
}
