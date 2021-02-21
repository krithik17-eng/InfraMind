# variables.tf


variable "access_key" {
     default = "<Access Key>"
}

variable "secret_key" {
     default = "<Secret Key>"
}

variable "region" {
     default = "ap-south-1"
}

variable "availbility_zone_1" {
     default = "ap-south-1a"
}

variable "availbility_zone_2" {
     default = "ap-south-1b"
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


variable "ami_id" {
     default = "ami-0db0b3ab7df22e366"
}

variable "instance_type" {
     default = "t2.micro"
}

variable "key_name" {
     default = "InfraMind"
}


