# variables.tf


variable "access_key" {
     default = "<>"
}

variable "secret_key" {
     default = "<>"
}

variable "region" {
     default = "ap-south-1"
}

variable "infra_mind_vpc_cidr" {
    default = "172.17.0.0/16"
}

variable "infra_mind_public_subnet_cidr" {
    default = "172.17.1.0/24"
}

variable "infra_mind_private_subnet_cidr" {
    default = "172.17.2.0/24"
}

