provider "aws" {
  region     = "eu-west-1"
}

resource "aws_instance" "jademaster" {
  ami           = "ami-f9dd458a"
  instance_type = "t2.micro"
  key_name      = "gateway"
  tags          = {
      Name = "jademaster"
  }
  user_data     = "${file("bootstrap/bootstrap.sh")}"
}
