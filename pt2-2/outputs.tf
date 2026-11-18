###############################################################################
# Outputs de la pràctica Pt2.2
###############################################################################

output "vpc_id" {
  description = "ID de la VPC-03 creada"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "Bloc d'adreces de la VPC-03"
  value       = aws_vpc.this.cidr_block
}

output "subnets" {
  description = "Resum de les dues subxarxes públiques"
  value = {
    A = {
      id        = aws_subnet.public_a.id
      cidr      = aws_subnet.public_a.cidr_block
      az        = aws_subnet.public_a.availability_zone
      public_ip = aws_subnet.public_a.map_public_ip_on_launch
    }
    B = {
      id        = aws_subnet.public_b.id
      cidr      = aws_subnet.public_b.cidr_block
      az        = aws_subnet.public_b.availability_zone
      public_ip = aws_subnet.public_b.map_public_ip_on_launch
    }
  }
}

output "internet_gateway_id" {
  description = "ID de l'Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID de la taula de rutes pública"
  value       = aws_route_table.public.id
}

output "security_group_id" {
  description = "ID del security group"
  value       = aws_security_group.this.id
}

output "instances" {
  description = "ID, IP privada i IP pública de les dues instàncies"
  value = {
    "ec2-a" = {
      id         = aws_instance.ec2_a.id
      private_ip = aws_instance.ec2_a.private_ip
      public_ip  = aws_instance.ec2_a.public_ip
    }
    "ec2-b" = {
      id         = aws_instance.ec2_b.id
      private_ip = aws_instance.ec2_b.private_ip
      public_ip  = aws_instance.ec2_b.public_ip
    }
  }
}

output "ssh_commands" {
  description = "Ordres SSH per connectar-hi amb la clau vockey"
  value = {
    "ec2-a" = "ssh -i labsuser.pem ec2-user@${aws_instance.ec2_a.public_ip}"
    "ec2-b" = "ssh -i labsuser.pem ec2-user@${aws_instance.ec2_b.public_ip}"
  }
}
