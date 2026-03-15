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
# # SECURITY GROUPS
# ############################################

############################################
# CREATE SECURITY GROUPS (NO RULES)
############################################

module "security_groups" {

  source = "./modules/security-group"

  for_each = var.security_groups

  org_name    = var.org_name
  environment = var.environment
  sg_name     = each.key

  vpc_id = module.vpc.vpc_id

  tags = local.common_tags
}

############################################
# FLATTEN RULE DEFINITIONS
############################################



############################################
# INGRESS RULES - CIDR BASED
############################################

resource "aws_security_group_rule" "allow_cidr_rules" {

  for_each = {
    for index, rule in local.ingress_rules :
    index => rule if length(rule.cidr_blocks) > 0
  }

  type = "ingress"

  security_group_id = module.security_groups[each.value.sg_name].security_group_id

  description = each.value.description
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol
  cidr_blocks = [ for cidr in each.value.cidr_blocks : cidr == "vpc" ? var.vpc_cidr : cidr ]

}

############################################
# EGRESS RULES - CIDR BASED
############################################

resource "aws_security_group_rule" "egress_cidr_rules" {

  for_each = {
    for index, rule in local.egress_rules :
    index => rule if length(rule.cidr_blocks) > 0
  }

  type = "egress"

  security_group_id = module.security_groups[each.value.sg_name].security_group_id

  description = each.value.description
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol

  cidr_blocks = [
    for cidr in each.value.cidr_blocks :
    cidr == "vpc" ? var.vpc_cidr : cidr
  ]
}

############################################
# INGRESS RULES - SG TO SG
############################################

resource "aws_security_group_rule" "allow_sg_rules" {

  for_each = {
    for index, rule in local.ingress_rules :
    index => rule if length(rule.source_sg_list) > 0
  }

  type = "ingress"

  security_group_id = module.security_groups[each.value.sg_name].security_group_id

  description = each.value.description
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol
  source_security_group_id = module.security_groups[each.value.source_sg_list[0]].security_group_id

}

############################################
# EGRESS RULES - SG TO SG
############################################

resource "aws_security_group_rule" "egress_sg_rules" {

  for_each = {
    for index, rule in local.egress_rules :
    index => rule if length(rule.source_sg_list) > 0
  }

  type = "egress"

  security_group_id = module.security_groups[each.value.sg_name].security_group_id

  description = each.value.description
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol

  source_security_group_id = module.security_groups[each.value.source_sg_list[0]].security_group_id
}

############################################
# EC2 IAM ROLE (SSM ACCESS)
############################################

module "ec2_iam_role" {

  source = "./modules/ec2-iam-role"

  org_name    = var.org_name
  environment = var.environment

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

  subnets_ids = module.vpc.private_subnets

  iam_instance_profile = module.ec2_iam_role.instance_profile_name

  security_groups = {
    for key, mod in module.security_groups :
    key => mod.security_group_id
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