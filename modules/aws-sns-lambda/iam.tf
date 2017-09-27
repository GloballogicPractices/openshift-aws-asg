resource "aws_iam_role" "lambda_function" {
  name = "role-lambda-${var.stack}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/* Profile is how we attach role to instances */
resource "aws_iam_instance_profile" "lambda_profile" {
  name  = "profile-lambda-${var.stack}-${var.environment}"
  role = "${aws_iam_role.lambda_function.name}"
}


resource "aws_iam_role_policy" "lambda_policy" {
  name = "policy-lambda-${var.stack}-${var.environment}"
  role = "${aws_iam_role.lambda_function.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:route53:::hostedzone*"
            ]
        },
        {
            "Action": [
                "route53:ListHostedZones"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:Describe*",
                "ec2:Describe*"
            ],
            "Resource": "*"
        }
     ]
  }
EOF
}
