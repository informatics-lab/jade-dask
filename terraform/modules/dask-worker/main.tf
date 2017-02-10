module "dask-bootstrap" {
  source  = "../dask-bootstrap"
  command = <<EOF
docker run
-d
--restart always
--cap-add SYS_ADMIN
--device /dev/fuse
--cap-add MKNOD
--entrypoint /bin/bash
--expose 39625
--expose 33270
--expose 42786
--expose 8789
-p 39625:39625
-p 33270:33270
-p 42786:42786
-p 8789:8789
quay.io/informaticslab/asn-serve:v1.0.1 -c
"mkdir -p /usr/local/share/notebooks/data/mogreps &&
s3fs mogreps /usr/local/share/notebooks/data/mogreps -o iam_role=jade-secrets &&
mkdir -p /usr/local/share/notebooks/data/mogreps-g &&
s3fs mogreps-g /usr/local/share/notebooks/data/mogreps-g -o iam_role=jade-secrets &&
dask-worker ${var.scheduler_address}:8786 --host $(wget -qO- http://instance-data/latest/meta-data/local-ipv4) --worker-port 39625 --http-port 33270 --nanny-port 42786 --bokeh-port 8789"
EOF
}




resource "aws_launch_configuration" "dask-workers" {
  # Amazon Linux ami
  image_id              = "ami-f9dd458a"
  instance_type         = "m3.large"

  key_name              = "gateway"
  iam_instance_profile  = "jade-secrets"
  user_data             = "${module.dask-bootstrap.rendered}"

  spot_price            = "0.1"
}

resource "aws_autoscaling_group" "dask-worker" {
  availability_zones    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  name                  = "${var.worker_name}s"
  max_size              = 1
  min_size              = 1
  desired_capacity      = 1
  health_check_grace_period = 300
  health_check_type     = "EC2"
  force_delete          = true
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
  autoscaling_group_name = "${aws_autoscaling_group.dask-worker.name}"
}

resource "aws_autoscaling_schedule" "start-dask-workers" {
  scheduled_action_name = "start-dask-workers"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  recurrence = "30 8 * * 1-5"
  autoscaling_group_name = "${aws_autoscaling_group.dask-worker.name}"
}
