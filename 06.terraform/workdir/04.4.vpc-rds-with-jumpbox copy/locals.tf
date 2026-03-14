## used in all modules for common tags
locals {

  common_tags = {
    Organization = var.org_name
    Environment  = var.environment
    ManagedBy    = "Terraform"
    Project      = "terraform-training"
  }
}

## used in vpc module and subnets module
locals {

  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  az_count = length(local.azs)

  public_subnets = [
    for i in range(local.az_count) :
    cidrsubnet(var.vpc_cidr, 8, i)
  ]

  private_subnets = [
    for i in range(local.az_count) :
    cidrsubnet(var.vpc_cidr, 8, i + 10)
  ]

  database_subnets = [
    for i in range(local.az_count) :
    cidrsubnet(var.vpc_cidr, 8, i + 20)
  ]

  public_subnet_names = [
    for az in local.azs :
    "${var.environment}-vpc-public-managed-${az}"
  ]

  private_subnet_names = [
    for az in local.azs :
    "${var.environment}-vpc-app-managed-${az}"
  ]

  database_subnet_names = [
    for az in local.azs :
    "${var.environment}-vpc-db-managed-${az}"
  ]

}