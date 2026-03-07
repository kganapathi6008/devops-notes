
module "security_group" {
  source = "./modules/security-group"

  org_name              = var.org_name
  environment           = var.environment
  ingress_rules         = var.ingress_rules
  egress_rules          = var.egress_rules
}

module "ec2" {
  source = "./modules/ec2"

  org_name          = var.org_name
  environment       = var.environment
  ec2_instances     = var.ec2_instances
  security_group_id = module.security_group.security_group_id
}
