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

resource "alicloud_security_group" "dask-worker" {
  name = "${var.worker_name}"
  vpc_id = "${var.vcp_id}"
}

resource "alicloud_security_group_rule" "allow_all_outgoing" {
  ip_protocol = "tcp"
  type        = "egress"
  port_range   = "1/65535"
  cidr_ip = "0.0.0.0/0"

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}

resource "alicloud_security_group_rule" "scheduler_incoming" {
  type        = "ingress"
  ip_protocol = "tcp"
  port_range   = "1/65535"
  cidr_ip = "${var.scheduler_address}/32"

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}





resource "alicloud_instance" "dask-worker" {
  image_id = "ubuntu_14_0405_64_40G_base_20170222.vhd"
  instance_type = "ecs.n4.small"
  vswitch_id = "${var.switch_id}"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["allow_from_bastion", "${alicloud_security_group.dask-worker.name}"]
  io_optimized         = "optimized"

  # TODO: 
  # iam_instance_profile = "jade-secrets"

  system_disk_size = 40

  # system_disk_category = "cloud_ssd" # ???

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }

}







# Looks a little like auto scaling only allows an image not user data.


# resource "aws_launch_configuration" "dask-workers" {
#   image_id              = "${data.aws_ami.debian.id}"
#   instance_type         = "m4.large"
#   root_block_device = {
#     volume_size = 80
#   }

#   key_name              = "bastion"
#   iam_instance_profile  = "jade-secrets"
#   user_data             = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["allow_from_bastion", "${alicloud_security_group.dask-worker.name}"]
#   spot_price            = "0.1"
# }

# resource "alicloud_ess_scaling_group" "dask-worker" {
#   scaling_group_name                  = "${var.worker_name}s"

#   max_size              = 1
#   min_size              = 1
#   vswitch_id = TBC
#   #desired_capacity      = 1
#   #health_check_grace_period = 300
#   #health_check_type     = "EC2"
#   #force_delete          = true
#   launch_configuration  = "${aws_launch_configuration.dask-workers.name}"

#   tag {
#     key                 = "Name"
#     value               = "${var.worker_name}"
#     propagate_at_launch = true
#   }

#   tag {
#     key                 = "environment"
#     value               = "${var.environment}"
#     propagate_at_launch = true
#   }
# }

# resource "aws_autoscaling_schedule" "stop-dask-workers" {
#   scheduled_action_name = "stop-dask-workers"
#   min_size = 0
#   max_size = 0
#   desired_capacity = 0
#   recurrence = "0 19 * * 1-5"
#   autoscaling_group_name = "${alicloud_ess_scaling_group.dask-worker.name}"
# }

# resource "aws_autoscaling_schedule" "start-dask-workers" {
#   scheduled_action_name = "start-dask-workers"
#   min_size = 0
#   max_size = 1
#   desired_capacity = 1
#   recurrence = "30 8 * * 1-5"
#   autoscaling_group_name = "${alicloud_ess_scaling_group.dask-worker.name}"
# }
