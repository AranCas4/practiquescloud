###############################################################################
# Variables de l'Exercici 1
###############################################################################

variable "aws_region" {
  description = "Regió AWS on es despleguen els recursos"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Zona de disponibilitat on es creen les instàncies"
  type        = string
  default     = "us-east-1a"
}

variable "project_name" {
  description = "Prefix que s'aplica al nom de tots els recursos"
  type        = string
  default     = "pt1-4-ex1"
}

variable "instance_type" {
  description = "Tipus d'instància EC2"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Nombre d'instàncies EC2 a crear"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count == 2
    error_message = "Aquesta pràctica requereix exactament 2 instàncies EC2."
  }
}

variable "key_name" {
  description = "Nom del Key Pair existent a AWS (a AWS Academy és 'vockey')"
  type        = string
  default     = "vockey"
}

variable "allowed_ssh_cidr" {
  description = "CIDR autoritzat a connectar-se per SSH"
  type        = string
  default     = "0.0.0.0/0"
}
