variable scheduler-name {}
variable worker-name {}
variable dns {}

data "template_file" "dask-scheduler-setup" {
    template            = "${file("bootstrap/dask.tpl")}"

    vars = {
        command         = "/home/ubuntu/anaconda3/bin/dask-scheduler"
    }
}

data "template_file" "dask-worker-setup" {
    template            = "${file("bootstrap/dask.tpl")}"

    vars = {
        command         = "/home/ubuntu/anaconda3/bin/dask-worker ${aws_instance.dask-scheduler.private_ip}:8786"
    }
}

resource "aws_instance" "dask-scheduler" {
  depends_on            = ["data.template_file.dask-scheduler-setup"]

  # official anaconda ami. Needs instance type with Paravirtual support
  ami                   = "ami-8f7617fc"
  instance_type         = "m3.large"
  
  key_name              = "gateway"
  user_data             = "${data.template_file.dask-scheduler-setup.rendered}" 
  security_groups       = ["default", "${aws_security_group.dask-scheduler.name}"]

  tags {
    Name                = "${var.scheduler-name}"
    environment         = "dev"
  }
}

resource "aws_security_group" "dask-scheduler" {
  name                  = "${var.scheduler-name}"

  ingress {
      from_port         = 8787
      to_port           = 8787
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
      from_port         = 0
      to_port           = 0
      protocol          = "-1"
      cidr_blocks       = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "dask-workers" {
  depends_on            = ["data.template_file.dask-worker-setup"]
  
  # official anaconda ami. Needs instance type with Paravirtual support
  image_id              = "ami-8f7617fc"
  instance_type         = "m3.large"

  key_name              = "gateway"
  user_data             = "${data.template_file.dask-worker-setup.rendered}"

  spot_price            = "0.1"
}

resource "aws_autoscaling_group" "dask-worker" {
  availability_zones    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  name                  = "${var.worker-name}s"
  max_size              = 1
  min_size              = 1
  desired_capacity      = 1
  health_check_grace_period = 300
  health_check_type     = "EC2"
  force_delete          = true
  launch_configuration  = "${aws_launch_configuration.dask-workers.name}"

  tag {
    key                 = "Name"
    value               = "${var.worker-name}"
    propagate_at_launch = true
  }
 
  tag {
    key                 = "environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

resource "aws_route53_record" "dask" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "${var.dns}."
  type = "A"
  ttl = "60"
  records = ["${aws_instance.dask-scheduler.private_ip}"]
}

