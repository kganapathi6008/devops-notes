locals {
  expanded_instances = flatten([
    for service_name, config in var.ec2_instances : [
      for i in range(config.instance_count) : {
        key               = "${service_name}-${i}"
        service_name      = service_name
        ami_id            = config.ami_id
        instance_type     = config.instance_type
        enable_monitoring = config.enable_monitoring
      }
    ]
  ])
}

resource "aws_instance" "example" {
  for_each = {
    for instance in local.expanded_instances :
    instance.key => instance
  }

  ami                    = each.value.ami_id
  instance_type          = each.value.instance_type
  monitoring             = each.value.enable_monitoring
  vpc_security_group_ids = [aws_security_group.dev_sg.id]

  tags = {
    Name        = "${each.value.service_name}-${var.environment}-${each.key}"
    Environment = var.environment
    Service     = each.value.service_name
  }

  depends_on = [aws_security_group.dev_sg]

  lifecycle {
    ignore_changes = [tags]
  }
}