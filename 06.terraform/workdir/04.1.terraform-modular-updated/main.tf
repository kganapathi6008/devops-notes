module "security_groups" {

  source = "./modules/security-group"

  for_each = var.security_groups

  org_name    = var.org_name
  environment = var.environment

  sg_name = each.key

  ingress_rules = each.value.ingress_rules
  egress_rules  = each.value.egress_rules
}

module "ec2" {

  source = "./modules/ec2"

  org_name      = var.org_name
  environment   = var.environment
  ec2_instances = var.ec2_instances

  security_groups = {
    for key, mod in module.security_groups :
    key => mod.security_group_id
  }

}