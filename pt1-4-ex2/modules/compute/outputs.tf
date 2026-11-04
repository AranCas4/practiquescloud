output "instance_ids" {
  description = "Mapa nom => ID d'instància"
  value       = { for key, instance in aws_instance.this : key => instance.id }
}

output "public_ips" {
  description = "Mapa nom => IP pública"
  value       = { for key, instance in aws_instance.this : key => instance.public_ip }
}

output "private_ips" {
  description = "Mapa nom => IP privada"
  value       = { for key, instance in aws_instance.this : key => instance.private_ip }
}

output "ami_id" {
  description = "AMI d'Amazon Linux 2023 utilitzada"
  value       = data.aws_ami.al2023.id
}
