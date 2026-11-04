###############################################################################
# Outputs de l'Exercici 2
###############################################################################

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "CIDR de la VPC"
  value       = module.network.vpc_cidr
}

output "subnet_ids" {
  description = "IDs de les subxarxes A, B i C"
  value       = module.network.subnet_ids
}

output "instance_ids" {
  description = "IDs de les 6 instàncies EC2"
  value       = module.compute.instance_ids
}

output "public_ips" {
  description = "IPs públiques de les 6 instàncies"
  value       = module.compute.public_ips
}

output "private_ips" {
  description = "IPs privades de les 6 instàncies"
  value       = module.compute.private_ips
}

output "ssh_commands" {
  description = "Ordres SSH per a cada instància"
  value = {
    for name, ip in module.compute.public_ips :
    name => "ssh -i labsuser.pem ec2-user@${ip}"
  }
}
