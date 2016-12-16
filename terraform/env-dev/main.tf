module "dask-scheduler" {
  source = "../modules/dask-scheduler"
  scheduler_name = "${var.scheduler-name}"
}

module "dask-worker" {
  source = "../modules/dask-worker"
  scheduler_address = "${module.dask-scheduler.private_ip}"
  worker_name = "${var.worker-name}"
}

resource "aws_route53_record" "dask" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "${var.dns}."
  type = "A"
  ttl = "60"
  records = ["${module.dask-scheduler.private_ip}"]
}
