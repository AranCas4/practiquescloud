###############################################################################
# Pràctica Pt2.2 - Infraestructura bàsica a AWS amb Terraform
#
# Provider: AWS a us-east-1
# VPC:       VPC-03 (10.0.0.0/16)
# Subxarxes: Public Subnet A (us-east-1a, 10.0.1.0/24)
#            Public Subnet B (us-east-1b, 10.0.2.0/24)
# Xarxa:     Internet Gateway + taula de rutes publica (0.0.0.0/0 -> IGW)
# Seguretat: SSH 0.0.0.0/0, ICMP 10.0.0.0/16, egress total
# Instancies: ec2-a i ec2-b (t3.micro, Amazon Linux, clau vockey)
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

# AMI oficial d'Amazon Linux 2023 (x86_64) a la regio us-east-1
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ------------------------------------------------------------------------------
# VPC i subxarxes públiques
# ------------------------------------------------------------------------------

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-03"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = var.az_a
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = var.az_b
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet B"
  }
}

# ------------------------------------------------------------------------------
# Internet Gateway, taula de rutes i associacions
# ------------------------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "pt2-2-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "pt2-2-public-rt"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# ------------------------------------------------------------------------------
# Security group
#   - SSH (22/tcp) des de qualsevol lloc
#   - ICMP (ping) només des de dins de la VPC
#   - Tot el trànsit sortint
# ------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  name        = "pt2-2-sg"
  description = "Pt2.2: SSH obert, ICMP nomes des de la VPC, egress total"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "SSH des de qualsevol lloc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP nomes des de dins de la VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Tot el transit sortint"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pt2-2-sg"
  }
}

# ------------------------------------------------------------------------------
# Instàncies EC2
# ------------------------------------------------------------------------------

resource "aws_instance" "ec2_a" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  # La ruta cap a Internet ha d'existir abans de llançar la instància
  depends_on = [aws_route_table_association.public_a]

  tags = {
    Name = "ec2-a"
  }
}

resource "aws_instance" "ec2_b" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_b.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  depends_on = [aws_route_table_association.public_b]

  tags = {
    Name = "ec2-b"
  }
}
