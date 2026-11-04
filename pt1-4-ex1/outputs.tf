###############################################################################
# Outputs de l'Exercici 1
###############################################################################

output "instance_ids" {
  description = "IDs de les dues instàncies EC2"
  value       = aws_instance.ec2[*].id
}

output "public_ips" {
  description = "IPs públiques de les instàncies"
  value       = aws_instance.ec2[*].public_ip
}

output "private_ips" {
  description = "IPs privades de les instàncies"
  value       = aws_instance.ec2[*].private_ip
}

output "ami_id" {
  description = "AMI d'Amazon Linux 2023 utilitzada"
  value       = data.aws_ami.al2023.id
}

output "ssh_commands" {
  description = "Ordres per connectar-se per SSH a cada instància"
  value = [
    for i, ip in aws_instance.ec2[*].public_ip :
    "ssh -i labsuser.pem ec2-user@${ip}"
  ]
}
