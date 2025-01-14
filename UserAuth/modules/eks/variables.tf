variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "nodegroup_backend" {
  type = map(string)
}

variable "nodegroup_frontend" {
  type = map(string)
}
variable "aws_region" {
  type = string
}
