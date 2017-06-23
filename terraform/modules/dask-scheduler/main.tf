data "template_file" "bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"
}

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

resource "alicloud_security_group_rule" "scheduler_incoming" {
  type        = "ingress"
  port_range        = "8786/8786"
  ip_protocol    = "tcp"
  cidr_ip = "0.0.0.0/0"
  policy            = "accept"

  security_group_id = "${alicloud_security_group.dask-scheduler.id}"
}

resource "alicloud_security_group_rule" "allow_ssh" {
  security_group_id = "${alicloud_security_group.dask-scheduler.id}"
  type = "ingress"
  cidr_ip= "0.0.0.0/0"
  policy = "accept"
  ip_protocol= "tcp"
  port_range= "22/22"
  priority= 1
}

resource "alicloud_instance" "dask-scheduler" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.small"
  vswitch_id = "${var.switch_id}"
  allocate_public_ip = true
  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_efficiency"

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
