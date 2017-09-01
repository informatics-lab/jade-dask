output "private_ip" {
  value = "${alicloud_instance.dask-scheduler.private_ip}"
}
