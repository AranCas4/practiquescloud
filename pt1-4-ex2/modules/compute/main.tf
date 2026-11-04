###############################################################################
# Mòdul compute: Security Group, AMI Amazon Linux 2023 i instàncies EC2
###############################################################################

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

resource "aws_security_group" "this" {
  name        = "${var.project_name}-sg"
  description = "SSH per a les 6 instancies de la practica Pt1.4"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH des del CIDR autoritzat"
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
# Bucle: 3 subxarxes x 2 instàncies = 6 instàncies
# El resultat és un mapa: { "A-1" = {...}, "A-2" = {...}, "B-1" = ... }
###############################################################################

locals {
  instances = merge([
    for subnet_key, subnet_id in var.subnet_ids : {
      for n in range(1, var.instances_per_subnet + 1) : "${subnet_key}-${n}" => {
        subnet_id   = subnet_id
        subnet_name = subnet_key
        number      = n
      }
    }
  ]...)
}

resource "aws_instance" "this" {
  for_each = local.instances

  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = var.key_name != "" ? var.key_name : null

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
    Name   = "${var.project_name}-ec2-${each.key}"
    Subnet = each.value.subnet_name
    Index  = each.value.number
  }
}
