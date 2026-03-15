output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}


output "security_groups" {

  value = {
    for name, sg in module.security_groups :
    name => {
      id   = sg.id
      name = sg.name
    }
  }

}

# output "ec2_instances" {
#   value = module.ec2.instances
# }


# output "rds_endpoints" {
#   value = module.rds.rds_endpoints
# }