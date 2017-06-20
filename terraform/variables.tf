# variables shared by all environments






variable "vpc_cidr" {
  default = "172.16.0.0/12"
}

variable "vswitch_cidr" {
  default = "172.16.0.0/21"
}

variable "zone" {
  default = "eu-central-1a"
}

variable "password" {
  default = "Test123456"
}
