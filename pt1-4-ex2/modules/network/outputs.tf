output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR de la VPC"
  value       = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "Mapa clau => ID de subxarxa"
  value       = { for key, subnet in aws_subnet.this : key => subnet.id }
}

output "subnet_cidrs" {
  description = "Mapa clau => CIDR de subxarxa"
  value       = { for key, subnet in aws_subnet.this : key => subnet.cidr_block }
}
