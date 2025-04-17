variable "allow_ip" {
  default = ["0.0.0.0/0"]
}

variable "environment" {
  default = "poc"
}

variable "private_subnets" {
  description = "The CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default = "us-east-2"
}

# can we modified by using .tfvars