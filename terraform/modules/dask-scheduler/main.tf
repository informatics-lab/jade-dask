module "dask-bootstrap" {
  source  = "../dask-bootstrap"
  command = "docker run -d --expose 8787 --expose 8786 -p 8786:8786 -p 8787:8787 --restart always quay.io/informaticslab/asn-serve dask-scheduler"
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
  # Amazon Linux ami
  ami           = "ami-f9dd458a"
  instance_type = "m3.large"

  key_name             = "gateway"
  user_data            = "${module.dask-bootstrap.rendered}"
  iam_instance_profile = "jade-secrets"
  security_groups      = ["default", "${aws_security_group.dask-scheduler.name}"]

  tags {
    Name        = "${var.scheduler_name}"
    environment = "${var.environment}"
  }
}
