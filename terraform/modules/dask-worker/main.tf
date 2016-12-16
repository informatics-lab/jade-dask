module "dask-bootstrap" {
  source  = "../dask-bootstrap"
  command = "/home/ubuntu/anaconda3/bin/dask-worker ${var.scheduler_address}:8786"
}

resource "aws_launch_configuration" "dask-workers" {
  # official anaconda ami. Needs instance type with Paravirtual support
  image_id              = "ami-8f7617fc"
  instance_type         = "m3.large"

  key_name              = "gateway"
  iam_instance_profile  = "jade-secrets"
  user_data             = "${module.dask-bootstrap.rendered}"

  spot_price            = "0.1"
}

resource "aws_autoscaling_group" "dask-worker" {
  availability_zones    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  name                  = "${var.worker_name}s"
  max_size              = 1
  min_size              = 1
  desired_capacity      = 1
  health_check_grace_period = 300
  health_check_type     = "EC2"
  force_delete          = true
  launch_configuration  = "${aws_launch_configuration.dask-workers.name}"

  tag {
    key                 = "Name"
    value               = "${var.worker_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "stop-dask-workers" {
  scheduled_action_name = "stop-dask-workers"
  min_size = 0
  max_size = 0
  desired_capacity = 0
  recurrence = "0 19 * * 1-5"
  autoscaling_group_name = "${aws_autoscaling_group.dask-worker.name}"
}

resource "aws_autoscaling_schedule" "start-dask-workers" {
  scheduled_action_name = "start-dask-workers"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  recurrence = "30 8 * * 1-5"
  autoscaling_group_name = "${aws_autoscaling_group.dask-worker.name}"
}
