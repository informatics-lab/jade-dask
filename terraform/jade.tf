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

resource "aws_eip" "jademaster" {
  instance = "${aws_instance.jademaster.id}"
  vpc = true
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

  ingress {
      from_port = 443
      to_port = 443
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

resource "aws_route53_record" "jupyterdev" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "dev.jupyter.informaticslab.co.uk."
  type = "A"
  ttl = "300"
  records = ["${aws_eip.jademaster.public_ip}"]
}
