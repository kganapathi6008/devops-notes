## used in all modules for common tags
locals {

  common_tags = {
    Organization = var.org_name
    Environment  = var.environment
    ManagedBy    = "Terraform"
    Project      = "terraform-training"
  }
}

## used in security group module
locals {

  ingress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for rule in sg.ingress_rules : {
        sg_name     = sg_name
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        description = rule.description

        cidr_blocks    = coalesce(rule.cidr_blocks, [])
        source_sg_list = coalesce(rule.source_sg_names, [])
      }
    ]
  ])

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