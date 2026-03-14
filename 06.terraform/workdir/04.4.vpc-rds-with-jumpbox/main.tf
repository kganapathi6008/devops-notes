# ############################################
# # VPC
# ############################################
module "vpc" {

  source = "./modules/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs = local.azs

  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  public_subnet_names   = local.public_subnet_names
  private_subnet_names  = local.private_subnet_names
  database_subnet_names = local.database_subnet_names

  tags = local.common_tags

}

# ############################################
# # KEY PAIRS
# ############################################

module "key_pairs" {

  source = "./modules/ec2-key-pair"

  for_each = var.key_pairs

  org_name     = var.org_name
  environment  = var.environment
  service_name = each.key

  tags = local.common_tags

}

# ############################################
# # SECURITY GROUPS
# ############################################

module "security_groups" {

  source = "./modules/security-group"

  for_each = var.security_groups

  org_name    = var.org_name
  environment = var.environment
  sg_name     = each.key

  vpc_id      = module.vpc.vpc_id

  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules

  tags = local.common_tags

}


# ############################################
# # EC2
# ############################################

module "ec2" {

  source = "./modules/ec2"

  org_name    = var.org_name
  environment = var.environment

  ec2_instances = var.ec2_instances

  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  security_groups = {
    for key, mod in module.security_groups :
    key => mod.security_group_id
  }

  key_pairs = {
    for key, mod in module.key_pairs :
    key => mod.key_name
  }

  tags = local.common_tags

}

############################################
# RDS
############################################

module "rds" {

  source = "./modules/rds"

  org_name    = var.org_name
  environment = var.environment

  rds_instances = var.rds_instances

  db_subnet_group_name = module.vpc.database_subnet_group

  db_subnets = module.vpc.database_subnets

  security_groups = {
    for key, mod in module.security_groups :
    key => mod.security_group_id
  }

  tags = local.common_tags

}