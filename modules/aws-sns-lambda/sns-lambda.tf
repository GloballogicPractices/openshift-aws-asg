// Create sns topic that would recieve notification from ASG
// A lambda function will be called that would register instances in route53


data "archive_file" "lambda_code" {
  type = "zip"
  source_dir = "${path.module}/files/"
  output_path = "${path.module}/files/lambda.zip"
}

resource "aws_sns_topic" "asg-notification" {
  name = "${var.sns_name}"
}


resource "aws_sns_topic_subscription" "topic_lambda" {
  topic_arn = "${aws_sns_topic.asg-notification.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.lambda.arn}"
}


resource "aws_lambda_permission" "with_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda.arn}"
    principal = "sns.amazonaws.com"
    source_arn = "${aws_sns_topic.asg-notification.arn}"
}



resource "aws_lambda_function" "lambda" {
  filename         = "${data.archive_file.lambda_code.output_path}"
  function_name    = "oc-r53-handler"
  role             = "${aws_iam_role.lambda_function.arn}"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python2.7"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda_code.output_path}"))}"

  environment {
    variables {
      ZONE = "${var.private_zone}"
    }
   }
 }

resource "null_resource" "module_dependency" {
  depends_on = [
                "aws_sns_topic.asg-notification",
                "aws_lambda_function.lambda"
               ]
}
