data "template_file" "bootstrap" {
  template = "${file("${path.module}/files/bootstrap.tpl")}"
  vars {
    scheduler_address = "${var.scheduler_address}"
  }
}

resource "alicloud_security_group" "dask-worker" {
  name = "${var.worker_name}"
  vpc_id = "${var.vcp_id}"
}

resource "alicloud_security_group_rule" "allow_ssh" {
  security_group_id = "${alicloud_security_group.dask-worker.id}"
  type = "ingress"
  cidr_ip= "0.0.0.0/0"
  policy = "accept"
  ip_protocol= "tcp"
  port_range= "22/22"
  priority= 1
}

resource "alicloud_security_group_rule" "allow_all_outgoing" {
  ip_protocol = "tcp"
  type        = "egress"
  port_range   = "1/65535"
  cidr_ip = "0.0.0.0/0"

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}

resource "alicloud_security_group_rule" "scheduler_incoming" {
  type        = "ingress"
  ip_protocol = "tcp"
  port_range   = "1/65535"
  cidr_ip = "${var.scheduler_address}/32"

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}


resource "alicloud_security_group_rule" "worker_to_worker_in" {
  type        = "ingress"
  port_range   = "1/65535"
  ip_protocol    = "tcp"
  cidr_ip = "0.0.0.0/0" # TODO: can we get the ip range of out AWS vcp?

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}

resource "alicloud_security_group_rule" "worker_to_worker_out" {
  type        = "egress"
  port_range   = "1/65535"
  ip_protocol    = "tcp"
  cidr_ip = "0.0.0.0/0" # TODO: can we get the ip range of out AWS vcp?

  security_group_id = "${alicloud_security_group.dask-worker.id}"
}


resource "alicloud_instance" "dask-worker" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker2" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker3" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker4" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}



resource "alicloud_instance" "dask-worker5" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker6" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker7" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker8" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker9" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker10" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker11" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker12" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker13" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker14" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

resource "alicloud_instance" "dask-worker15" {
  image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
  instance_type = "ecs.n4.xlarge"
  vswitch_id = "${var.switch_id}"
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 5
  system_disk_category = "cloud_ssd"

  password= "${var.password}"
  user_data            = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${alicloud_security_group.dask-worker.id}"]
  io_optimized         = "optimized"

  system_disk_size = 40

  tags = {
    Name        = "${var.worker_name}"
    environment = "${var.environment}"
  }
}

# resource "alicloud_instance" "dask-worker16" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker17" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker18" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker19" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker20" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker21" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker22" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker23" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker24" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker25" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker26" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker27" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker28" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }

# resource "alicloud_instance" "dask-worker29" {
#   image_id = "ubuntu_16_0402_64_40G_alibase_20170525.vhd"
#   instance_type = "ecs.n4.xlarge"
#   vswitch_id = "${var.switch_id}"
#   internet_charge_type = "PayByTraffic"
#   internet_max_bandwidth_out = 5
#   system_disk_category = "cloud_ssd"

#   password= "${var.password}"
#   user_data            = "${data.template_file.bootstrap.rendered}"
#   security_groups       = ["${alicloud_security_group.dask-worker.id}"]
#   io_optimized         = "optimized"

#   system_disk_size = 40

#   tags = {
#     Name        = "${var.worker_name}"
#     environment = "${var.environment}"
#   }
# }




/** AWS **/


resource "aws_security_group" "dask-worker" {
  name = "alicloud-hybrid-${var.worker_name}"
}

resource "aws_security_group_rule" "allow_all_outgoing" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.dask-worker.id}"
}

resource "aws_security_group_rule" "scheduler_incoming" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["${var.scheduler_address}/32"]

  security_group_id = "${aws_security_group.dask-worker.id}"
}

resource "aws_security_group_rule" "worker_to_worker_in" {
  type        = "ingress"
  from_port   = 1
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # TODO: can we get the ip range of out Alibaba vcp?

  security_group_id = "${aws_security_group.dask-worker.id}"
}

resource "aws_security_group_rule" "worker_to_worker_out" {
  type        = "egress"
  from_port   = 1
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # TODO: can we get the ip range of out Alibaba vcp?

  security_group_id = "${aws_security_group.dask-worker.id}"
}


resource "aws_launch_configuration" "dask-workers" {
  image_id              = "ami-6d48500b"
  instance_type         = "m4.large"
  root_block_device = {
    volume_size = 80
  }

  key_name              = "gateway"
  iam_instance_profile  = "jade-secrets"
  user_data             = "${data.template_file.bootstrap.rendered}"
  security_groups       = ["${aws_security_group.dask-worker.name}", "default"]
  spot_price            = "0.1"
}

resource "aws_autoscaling_group" "dask-worker" {
  name                  = "ali-hybrid-${var.worker_name}s"
  availability_zones    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  max_size              = 20
  min_size              = 1
  desired_capacity      = 15
  health_check_grace_period = 300
  health_check_type     = "EC2"
  force_delete          = true
  launch_configuration  = "${aws_launch_configuration.dask-workers.name}"

  tag {
    key                 = "Name"
    value               = "ali-hybrid-${var.worker_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
}