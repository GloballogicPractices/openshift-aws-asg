/* We use this to track dependecies between each modules */
output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "app-cluster-sg-id" {
   value = "${aws_security_group.master-sg.id}"
}

output "asg-name" {
   value = "${aws_autoscaling_group.oc-master-cluster.name}"
}
