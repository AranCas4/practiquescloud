###############################################################################
# Pràctica Pt1.4 - Exercici 1
# Dues instàncies EC2 t3.micro amb Amazon Linux 2023 a us-east-1
#
# Autor: ASIX2 - Cloud Computing
# Ús:
#   terraform init
#   terraform plan
#   terraform apply -auto-approve
#   terraform destroy -auto-approve
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

###############################################################################
# Dades de la VPC per defecte i de la AMI d'Amazon Linux 2023
###############################################################################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # Limita a una AZ on t3.micro estigui suportat (us-east-1e no ho està)
  filter {
    name   = "availability-zone"
    values = [var.availability_zone]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

###############################################################################
# Grup de seguretat: només SSH (22/tcp)
###############################################################################

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-sg"
  description = "Acces SSH a les instancies de la practica Pt1.4"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH des de la IP permesa"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Sortida a Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

###############################################################################
# Dues instàncies EC2 (count = 2)
###############################################################################

resource "aws_instance" "ec2" {
  count = var.instance_count

  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = sort(data.aws_subnets.default.ids)[count.index % length(data.aws_subnets.default.ids)]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name

  # Bones pràctiques: exigir IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = format("%s-ec2-%02d", var.project_name, count.index + 1)
    Role = "web"
  }
}
