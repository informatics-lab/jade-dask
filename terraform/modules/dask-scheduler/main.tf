module "dask-bootstrap" {
  source  = "../dask-bootstrap"
  command = "/home/ubuntu/anaconda3/bin/dask-scheduler"
}

resource "aws_security_group" "dask-scheduler" {
  name = "${var.scheduler_name}"
}

resource "aws_security_group_rule" "allow_all_outgoing" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.dask-scheduler.id}"
}

resource "aws_security_group_rule" "dashboard_incoming" {
  type        = "ingress"
  from_port   = 8787
  to_port     = 8787
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.dask-scheduler.id}"
}

resource "aws_instance" "dask-scheduler" {
  # official anaconda ami. Needs instance type with Paravirtual support
  ami           = "ami-8f7617fc"
  instance_type = "m3.large"

  key_name             = "gateway"
  user_data            = "${module.dask-bootstrap.rendered}"
  iam_instance_profile = "jade-secrets"
  security_groups      = ["default", "${aws_security_group.dask-scheduler.name}"]

  tags {
    Name        = "${var.scheduler_name}"
    environment = "dev"
  }
}
