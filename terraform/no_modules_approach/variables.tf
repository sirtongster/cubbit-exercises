variable "project_name" {
  type    = string
  default = "cubbit"
}

variable "env" {
  default = "master"
}

variable "vpc_cidr_block" {
  type    = list(string)
  default = ["10.24.0.0/16"]
}

variable "sn1_cidr_block" {
  type    = list(string)
  default = ["10.24.1.0/24"]
}

variable "sn2_cidr_block" {
  type    = list(string)
  default = ["10.24.2.0/24"]
}

// Using variable.tfvar to populate
variable "access_key_id" {}
variable "secret_access_key" {}
variable "region" {}
variable "shared_credentials_file" {}