variable "cidr" {
    description = "The CIDR block (0.0.0.0/0) for the VPC."
    default = "10.253.252.0/24"
}
variable "howmany" {
    description = "The number of instances to build."
    default = 2
}
variable "pe_server" {
    description = "The FQDN of the PE Server."
    default = "yourpeserver.ip.us-west-1.compute.amazonaws.com"
}

variable "region" {
    description = "The AWS region to build in."
    default = "us-west-2"
}

variable "environment" {
    description = "Production / Development"
    default = "production"
}
variable "subnet" {
    description = "Subnet ID"
    default = "subnet-12345"
}
variable "vpc" {
    description = "vpc"
    default = "vpc-12345"
}
