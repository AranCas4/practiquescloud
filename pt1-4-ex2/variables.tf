###############################################################################
# Variables de l'Exercici 2
###############################################################################

variable "aws_region" {
  description = "Regió AWS on es despleguen els recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix que s'aplica al nom de tots els recursos"
  type        = string
  default     = "pt1-4-ex2"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC principal"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Zona de disponibilitat comuna a les 3 subxarxes"
  type        = string
  default     = "us-east-1a"
}

variable "subnets" {
  description = "Mapa de subxarxes: clau => CIDR (les 3 han de ser a la mateixa AZ)"
  type = map(object({
    cidr_block = string
  }))

  default = {
    A = { cidr_block = "10.0.32.0/25" }
    B = { cidr_block = "10.0.30.0/23" }
    C = { cidr_block = "10.0.33.0/28" }
  }

  validation {
    condition     = alltrue([for s in values(var.subnets) : can(cidrhost(s.cidr_block, 0))])
    error_message = "Totes les subxarxes han de tenir un CIDR IPv4 vàlid."
  }

  validation {
    condition     = length(var.subnets) == 3
    error_message = "Cal definir exactament 3 subxarxes (A, B i C)."
  }
}

variable "instance_type" {
  description = "Tipus d'instància EC2"
  type        = string
  default     = "t3.micro"
}

variable "instances_per_subnet" {
  description = "Nombre d'instàncies EC2 per subxarxa"
  type        = number
  default     = 2

  validation {
    condition     = var.instances_per_subnet == 2
    error_message = "Aquesta pràctica requereix 2 instàncies per subxarxa (6 en total)."
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
