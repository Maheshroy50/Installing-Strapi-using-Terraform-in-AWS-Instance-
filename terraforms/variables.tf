variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "strapi-access-key"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "strapi-server"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
