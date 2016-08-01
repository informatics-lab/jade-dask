provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "jademaster" {
  ami                   = "ami-f9dd458a"
  instance_type         = "t2.micro"
  key_name              = "gateway"
  user_data             = "${file("bootstrap/bootstrap.sh")}"
  iam_instance_profile  = "jade-secrets"
  security_groups        = ["default", "jademaster"]

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
