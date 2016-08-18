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
  instance_type         = "m3.xlarge"
  
  key_name              = "gateway"
  user_data             = "${data.template_file.dask-scheduler-setup.rendered}" 
  security_groups       = ["default", "${aws_security_group.dask-scheduler.name}"]

  tags = {
    Name                = "dask-scheduler"
  }

  root_block_device = {
    volume_size         = 20
  }

}

resource "aws_instance" "dask-worker" {
  depends_on            = ["data.template_file.dask-worker-setup"]
  ami                   = "ami-8f7617fc"
  instance_type         = "m3.xlarge"
  key_name              = "gateway"
  user_data             = "${data.template_file.dask-worker-setup.rendered}"

  tags = {
    Name                = "dask-worker"
  }

  root_block_device = {
    volume_size         = 20
  }
}

resource "aws_security_group" "dask-scheduler" {
  name                  = "dask-scheduler"

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
