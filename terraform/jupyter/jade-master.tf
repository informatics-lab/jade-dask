resource "aws_instance" "jademaster" {
  ami                   = "ami-f9dd458a"
  instance_type         = "t2.large"
  key_name              = "gateway"
  user_data             = "${file("bootstrap/bootstrap.sh")}"
  iam_instance_profile  = "jade-secrets"
  security_groups        = ["default", "${aws_security_group.jademaster.name}"]

  tags = {
    Name = "jademaster"
  }

  root_block_device = {
    volume_size = 20
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

resource "aws_security_group_rule" "allow_from_slave" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"

    security_group_id = "${aws_security_group.jademaster.id}"
    source_security_group_id = "${aws_security_group.jadeslave.id}"
}

resource "aws_route53_record" "jupyterdev" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "devel.jupyter.informaticslab.co.uk."
  type = "A"
  ttl = "60"
  records = ["${aws_instance.jademaster.public_ip}"]
}
