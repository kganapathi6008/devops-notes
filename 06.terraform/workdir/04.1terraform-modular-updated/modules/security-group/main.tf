resource "aws_security_group" "ec2_security_group" {

  name        = "${var.org_name}-${var.environment}-ec2-sg"
  description = "Security group for ${var.environment} EC2 instances"

  dynamic "ingress" {

    for_each = {
      for index, rule in var.ingress_rules :
      index => rule
    }

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {

    for_each = {
      for index, rule in var.egress_rules :
      index => rule
    }

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}