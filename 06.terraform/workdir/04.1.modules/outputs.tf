output "key_pairs" {

  description = "Generated key pairs"

  value = {
    for key, mod in module.key_pairs :
    key => {
      key_name = mod.key_name
      key_file = mod.key_file
    }
  }

}

output "security_groups" {
  value = {
    for k, sg in module.security_groups :
    k => {
      id   = sg.security_group_id
      name = sg.security_group_name
    }
  }
}

output "ec2_instances" {
  value = module.ec2.instances
}

