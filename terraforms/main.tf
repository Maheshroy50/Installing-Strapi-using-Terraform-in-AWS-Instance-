terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"

  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "compute" {
  source = "./modules/compute"

  instance_type      = var.instance_type
  key_name           = var.key_name
  instance_name      = var.instance_name
  environment        = var.environment
  security_group_ids = [module.networking.security_group_id]
}
