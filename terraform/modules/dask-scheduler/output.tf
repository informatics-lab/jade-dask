output "private_ip" {
  value = "${aws_instance.dask-scheduler.private_ip}"
}