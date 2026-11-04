variable "project_name" {
  description = "Prefix dels recursos"
  type        = string
}

variable "vpc_id" {
  description = "VPC on es crea el Security Group"
  type        = string
}

variable "subnet_ids" {
  description = "Mapa clau => ID de subxarxa on desplegar les instàncies"
  type        = map(string)
}

variable "instance_type" {
  description = "Tipus d'instància EC2"
  type        = string
}

variable "instances_per_subnet" {
  description = "Nombre d'instàncies per subxarxa"
  type        = number
}

variable "key_name" {
  description = "Key Pair existent a AWS"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR autoritzat per SSH"
  type        = string
  default     = "0.0.0.0/0"
}
