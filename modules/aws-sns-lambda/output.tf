output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "sns-arn" {
   value = "${aws_sns_topic.asg-notification.arn}"
}

output "sns-id" {
   value = "${aws_sns_topic.asg-notification.id}"
}
