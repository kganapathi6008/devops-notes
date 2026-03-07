output "security_group_ids" {

  value = {
    for k, v in module.security_groups :
    k => v.security_group_id
  }

}