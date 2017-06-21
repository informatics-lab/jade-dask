# variables shared by all environments

provider "aws" {
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::536099501702:role/admin"
  }
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
