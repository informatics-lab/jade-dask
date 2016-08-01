provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "jademaster" {
  ami                   = "ami-f9dd458a"
  instance_type         = "t2.micro"
  key_name              = "gateway"
  user_data             = "${file("bootstrap/bootstrap.sh")}"
  iam_instance_profile  = "jade-secrets"

  tags = {
    Name = "jademaster"
  }
}
