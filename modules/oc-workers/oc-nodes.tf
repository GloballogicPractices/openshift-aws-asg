/*
worker cluster
*/


/* This is used to generate data about ami to be used */
data "aws_ami" "worker" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = ["${var.ami_owner_name}"]
  }

  filter {
    name   = "name"
    values = ["${var.ami_name_regex}"]
  }

}


resource "aws_launch_configuration" "oc-worker-cluster" {
  image_id                    = "${data.aws_ami.worker.id}"
  name_prefix                 = "oc-worker-${var.stack}-${var.environment}"
  instance_type               = "${var.worker_instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.aws_key_name}"
  security_groups             = ["${aws_security_group.worker-sg.id}"]
  user_data                   = "${data.template_file.oc-worker.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.worker_profile.name}"
  placement_tenancy           = "default"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  connection {
    user  = "ec2-user"
    agent = true
  }


  // We have to set this to true to avoid error
  // ResourceInUse: Cannot delete launch configuration
  // {lc_name} because it is attached to AutoScalingGroup
  lifecycle {
    create_before_destroy = true
  }


}


resource "aws_autoscaling_group" "oc-worker-cluster" {
  # Scheduling implemented for this asg
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  name                      = "OC-WORKER-CLUSTER-${upper(var.stack)}-${upper(var.environment)}"
  max_size                  = "${var.oc_worker_max_size}"
  min_size                  = "${var.oc_worker_min_size}"
  health_check_grace_period = 100
  health_check_type         = "EC2"
  // We dont need desired capacity for dynamic scaling
  #desired_capacity          = "${var.oc_worker_desired_size}"
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.oc-worker-cluster.name}"


  lifecycle {
    create_before_destroy   = true
  }


  tag {
    key                 = "Name"
    value               = "OC-WORKER-NODE-${upper(var.stack)}-${upper(var.environment)}"
    propagate_at_launch = true
  }

  tag {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
  }

  // This will decide Ansible role to be applied via dynamic inventory
  tag {
    key                 = "Role"
    value               = "oc-worker"
    propagate_at_launch = true
  }

  tag{
    key                 = "Stack"
    value               = "OC"
    propagate_at_launch = true
  }

  depends_on = ["aws_launch_configuration.oc-worker-cluster"]
}

resource "aws_autoscaling_lifecycle_hook" "worker-launch" {
  name                   = "asg-hook-${var.stack}-${var.environment}"
  autoscaling_group_name = "${aws_autoscaling_group.oc-worker-cluster.name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"


  notification_target_arn = "${var.sns-arn}"
  role_arn                = "${aws_iam_role.sns_role.arn}"
}


resource "aws_autoscaling_lifecycle_hook" "worker-terminate" {
  name                   = "asg-hook-${var.stack}-${var.environment}"
  autoscaling_group_name = "${aws_autoscaling_group.oc-worker-cluster.name}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"


  notification_target_arn = "${var.sns-arn}"
  role_arn                = "${aws_iam_role.sns_role.arn}"
}


/* We use this to create this as a dependency for other modules */
resource "null_resource" "module_dependency" {
  depends_on = ["aws_autoscaling_group.oc-worker-cluster"]
}
