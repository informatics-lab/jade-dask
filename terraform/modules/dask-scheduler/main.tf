data "template_file" "docker-compose" {
  template = "${file("${path.module}/files/docker-compose.yml")}"
}

data "template_file" "bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"
  vars {
    compose_file = "${data.template_file.docker-compose.rendered}"
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

resource "alicloud_security_group" "dask-scheduler" {
  name = "${var.scheduler_name}"
  vpc_id = "${var.vcp_id}"
}




resource "alicloud_security_group_rule" "allow_all_outgoing" {
  ip_protocol = "tcp"
  type        = "egress"
  policy            = "accept"
  cidr_ip = "0.0.0.0/0"
  port_range        = "1/65535"

  security_group_id = "${alicloud_security_group.dask-scheduler.id}"
}

resource "alicloud_security_group_rule" "dashboard_incoming" {
  type        = "ingress"
  port_range        = "8787/8787"
  ip_protocol    = "tcp"
  cidr_ip = "0.0.0.0/0"
  policy            = "accept"

  security_group_id = "${alicloud_security_group.dask-scheduler.id}"
}

resource "alicloud_instance" "dask-scheduler" {
  image_id = "ubuntu_14_0405_64_40G_base_20170222.vhd"
  instance_type = "ecs.n4.small"
  vswitch_id = "${var.switch_id}"
  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"

  #iam_instance_profile = "jade-secrets"

  system_disk_size = 40

  security_groups  = ["${alicloud_security_group.dask-scheduler.id}"]
  io_optimized         = "optimized"

  # system_disk_category = "cloud_ssd" # ???

  tags {
    Name        = "${var.scheduler_name}"
    environment = "${var.environment}"
  }

}
