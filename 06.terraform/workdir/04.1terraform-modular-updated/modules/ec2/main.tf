locals {
  computed_ec2_instances = flatten([
    for service_name, config in var.ec2_instances : [
      for i in range(config.instance_count) : {
        instance_key        = "${service_name}-${i}"
        service_name      = service_name
        index             = i
        ami_id            = config.ami_id
        instance_type     = config.instance_type
        enable_monitoring = config.enable_monitoring
      }
    ]
  ])
}

resource "aws_instance" "example" {
  for_each = {
    for instance in local.computed_ec2_instances :
    instance.instance_key => instance
  }

  ami                    = each.value.ami_id
  instance_type          = each.value.instance_type
  monitoring             = each.value.enable_monitoring
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = "${var.org_name}-${each.value.service_name}-${var.environment}-${each.value.index}"
    Environment = var.environment
    Service     = each.value.service_name
  }

  # lifecycle {
  #   ignore_changes = [tags]
  # }
}