variable "vpc_cidr" {
  type = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "project_name" {
  type = string
  description = "Project name"
}

variable "public_subnet_1_cidr" {
  type = string
  description = "Public Subnet 1 CIDR block"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type = string
  description = "Public Subnet 2 CIDR block"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  type = string
  description = "Private Subnet 1 CIDR block"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  type = string
  description = "Private Subnet 2 CIDR block"
  default     = "10.0.4.0/24"
}