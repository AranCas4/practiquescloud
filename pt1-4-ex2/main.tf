###############################################################################
# Pràctica Pt1.4 - Exercici 2
# VPC 10.0.0.0/16 + 3 subxarxes a us-east-1a + 6 instàncies EC2 t3.micro
#
# Arquitectura modular:
#   modules/network -> VPC, subxarxes, Internet Gateway i route table
#   modules/compute -> Security Group, AMI i les 6 instàncies EC2
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = "lab"
      ManagedBy   = "terraform"
    }
  }
}

module "network" {
  source = "./modules/network"

  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  availability_zone = var.availability_zone
  subnets           = var.subnets
}

module "compute" {
  source = "./modules/compute"

  project_name         = var.project_name
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.subnet_ids
  instance_type        = var.instance_type
  instances_per_subnet = var.instances_per_subnet
  key_name             = var.key_name
  allowed_ssh_cidr     = var.allowed_ssh_cidr
}
