variable "project_name" {
  description = "Prefix dels recursos"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "availability_zone" {
  description = "AZ comuna de les subxarxes"
  type        = string
}

variable "subnets" {
  description = "Mapa de subxarxes (clau => objecte amb cidr_block)"
  type = map(object({
    cidr_block = string
  }))
}
