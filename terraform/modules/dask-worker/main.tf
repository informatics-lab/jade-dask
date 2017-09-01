data "template_file" "docker-compose" {
  template = "${file("${path.module}/files/docker-compose.tpl")}"
  vars {
    scheduler_address = "${var.scheduler_address}"
  }
}

data "template_file" "tds_catalog" {
  template = "${file("${path.module}/files/catalog.tpl")}"
}

data "template_file" "bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"
  vars {
    compose_file = "${data.template_file.docker-compose.rendered}"
    catalog_file = "${data.template_file.tds_catalog.rendered}"
  }
}


# data "aws_ami" "debian" {
#   filter {
#     name = "virtualization-type",
#     values = ["hvm"]
#   }
#   filter {
#     name = "name",
#     values = ["debian-jessie-*"]
#   }
#   owners = ["379101102735"]
#   most_recent = true
# }

resource "alicloud_security_group" "dask-worker" {
  name = "${var.worker_name}"
}

resource "alicloud_security_group_rule" "allow_all_outgoing" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}

resource "alicloud_security_group_rule" "scheduler_incoming" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["${var.scheduler_address}/32"]

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}

resource "aws_launch_configuration" "dask-workers" {
  image_id              = "${data.aws_ami.debian.id}"
  instance_type         = "m4.large"
  root_block_device = {
    volume_size = 80
  }

  key_name              = "bastion"
  iam_instance_profile  = "jade-secrets"
  user_data             = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["allow_from_bastion", "${alicloud_security_group.dask-worker.name}"]
  spot_price            = "0.1"
}

resource "alicloud_ess_scaling_group" "dask-worker" {
  scaling_group_name                  = "${var.worker_name}s"

  max_size              = 1
  min_size              = 1
  vswitch_id = TBC
  #desired_capacity      = 1
  #health_check_grace_period = 300
  #health_check_type     = "EC2"
  #force_delete          = true
  launch_configuration  = "${aws_launch_configuration.dask-workers.name}"

  tag {
    key                 = "Name"
    value               = "${var.worker_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "stop-dask-workers" {
  scheduled_action_name = "stop-dask-workers"
  min_size = 0
  max_size = 0
  desired_capacity = 0
  recurrence = "0 19 * * 1-5"
  autoscaling_group_name = "${alicloud_ess_scaling_group.dask-worker.name}"
}

resource "aws_autoscaling_schedule" "start-dask-workers" {
  scheduled_action_name = "start-dask-workers"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  recurrence = "30 8 * * 1-5"
  autoscaling_group_name = "${alicloud_ess_scaling_group.dask-worker.name}"
}
