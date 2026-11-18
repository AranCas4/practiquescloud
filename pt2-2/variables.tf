###############################################################################
# Variables de la pràctica Pt2.2
###############################################################################

variable "aws_region" {
  description = "Regió AWS de desplegament (requisit: us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix per etiquetar els recursos"
  type        = string
  default     = "pt2-2"
}

variable "vpc_cidr" {
  description = "Bloc d'adreces de la VPC-03"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = var.vpc_cidr == "10.0.0.0/16"
    error_message = "La pràctica exigeix exactament el CIDR 10.0.0.0/16."
  }
}

variable "subnet_a_cidr" {
  description = "CIDR de la Public Subnet A"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = var.subnet_a_cidr == "10.0.1.0/24"
    error_message = "La Public Subnet A ha de ser 10.0.1.0/24."
  }
}

variable "subnet_b_cidr" {
  description = "CIDR de la Public Subnet B"
  type        = string
  default     = "10.0.2.0/24"

  validation {
    condition     = var.subnet_b_cidr == "10.0.2.0/24"
    error_message = "La Public Subnet B ha de ser 10.0.2.0/24."
  }
}

variable "az_a" {
  description = "Zona de disponibilitat de la subxarxa A"
  type        = string
  default     = "us-east-1a"

  validation {
    condition     = var.az_a == "us-east-1a"
    error_message = "La Public Subnet A ha d'estar a us-east-1a."
  }
}

variable "az_b" {
  description = "Zona de disponibilitat de la subxarxa B"
  type        = string
  default     = "us-east-1b"

  validation {
    condition     = var.az_b == "us-east-1b"
    error_message = "La Public Subnet B ha d'estar a us-east-1b."
  }
}

variable "instance_type" {
  description = "Tipus d'instància EC2"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = var.instance_type == "t3.micro"
    error_message = "La pràctica exigeix instàncies t3.micro."
  }
}

variable "key_name" {
  description = "Nom del Key Pair existent a AWS (AWS Academy: vockey)"
  type        = string
  default     = "vockey"
}
