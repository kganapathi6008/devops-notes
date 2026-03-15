locals {

  module_tags = {
    Component = "network"
    Module    = "vpc"
  }

  tags = merge(
    var.tags,
    local.module_tags
  )

}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.name
  cidr = var.cidr

  azs = var.azs

  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  public_subnet_names   = var.public_subnet_names
  private_subnet_names  = var.private_subnet_names
  database_subnet_names = var.database_subnet_names

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  database_subnet_tags = {
    Tier = "database"
  }

}