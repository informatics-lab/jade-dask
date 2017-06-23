module "dask-scheduler" {
  source = "../modules/dask-scheduler"
  scheduler_name = "${var.scheduler-name}"
  environment = "${var.environment}"
  password = "${var.password}"
  switch_id = "${alicloud_vswitch.vsw.id}"
  vcp_id = "${alicloud_vpc.default.id}"
}

module "dask-worker" {
  source = "../modules/dask-worker"
  scheduler_address = "${module.dask-scheduler.address}"
  worker_name = "${var.worker-name}"
  environment = "${var.environment}"
  password = "${var.password}"
  switch_id = "${alicloud_vswitch.vsw.id}"
  vcp_id = "${alicloud_vpc.default.id}"
}

resource "alicloud_vpc" "default" {
  name = "tf-vpc"
  cidr_block = "${var.vpc_cidr}"
}

resource "alicloud_vswitch" "vsw" {
  vpc_id = "${alicloud_vpc.default.id}"
  cidr_block = "${var.vswitch_cidr}"
  availability_zone = "${var.zone}"
}

# resource "aws_route53_record" "dask" {
#   zone_id = "Z3USS9SVLB2LY1"
#   name = "${var.dns}."
#   type = "A"
#   ttl = "60"
#   records = ["${module.dask-scheduler.private_ip}"]
# }
