# variables shared by all environments

provider "aws" {
  region = "eu-west-2"
}

variable "tf_s3_bucket" {
  default = "informatics-jade-terraform"
}

variable "prod_state_file" {
  default = "dask/prod/production.tfstate"
}

variable "dev_state_file" {
  default = "dask/dev/dev.tfstate"
}


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
