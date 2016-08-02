provider "aws" {
  region  = "eu-west-1"
}

resource "aws_instance" "jademaster" {
  ami                   = "ami-f9dd458a"
  instance_type         = "t2.micro"
  key_name              = "gateway"
  user_data             = "${file("bootstrap/bootstrap.sh")}"
  iam_instance_profile  = "jade-secrets"
  security_groups        = ["default", "${aws_security_group.jademaster.name}"]

  tags = {
    Name = "jademaster"
  }
}

resource "aws_security_group" "jademaster" {
  name = "jademaster"
  description = "Allow jade traffic"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "jade" {
  name = "jade-elb"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  listener {
    instance_port = 443
    instance_protocol = "ssl"
    lb_port = 443
    lb_protocol = "ssl"
    ssl_certificate_id = "arn:aws:acm:eu-west-1:536099501702:certificate/90e79c0e-1b87-4848-a9a0-5731a32905a0"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/hub/logo"
    interval = 30
  }

  instances = ["${aws_instance.jademaster.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "jade-elb"
  }
}

resource "aws_route53_record" "jupyterdev" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "dev.jupyter.informaticslab.co.uk."
  type = "A"

  alias {
    name = "${aws_elb.jade.dns_name}"
    zone_id = "${aws_elb.jade.zone_id}"
    evaluate_target_health = true
  }
}
