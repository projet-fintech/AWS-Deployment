variable "region" {
  description = "AWS region"
  default     = "eu-west-3"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}