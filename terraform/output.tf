output "scheduler_private" {
   value = "${module.dask-scheduler.private_ip}"
}   

output "scheduler_public" {
   value = "${module.dask-scheduler.public_ip}"
}   