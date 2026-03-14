output "instances" {
  value = {
    for key, inst in aws_instance.example : key => {
      instance_id                = inst.id
      instance_private_ip        = inst.private_ip
      instance_availability_zone = inst.availability_zone
      instance_type              = inst.instance_type
      instance_vpc               = inst.vpc_security_group_ids
      instance_tags              = inst.tags
    }
  }
}