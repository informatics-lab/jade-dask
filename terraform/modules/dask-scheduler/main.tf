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
}

resource "alicloud_security_group_rule" "allow_all_outgoing" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${alicloud_security_group.dask-scheduler.id}"
}

resource "alicloud_security_group_rule" "dashboard_incoming" {
  type        = "ingress"
  from_port   = 8787
  to_port     = 8787
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${alicloud_security_group.dask-scheduler.id}"
}

resource "alicloud_instance" "dask-scheduler" {
  image_id = "ubuntu_14_0405_64_40G_base_20170222.vhd"
  instance_type = "ecs.n4.small"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"

  iam_instance_profile = "jade-secrets"

  system_disk_size = 40

  # system_disk_category = "cloud_ssd" # ???

  tags {
    Name        = "${var.scheduler_name}"
    environment = "${var.environment}"
  }

}
