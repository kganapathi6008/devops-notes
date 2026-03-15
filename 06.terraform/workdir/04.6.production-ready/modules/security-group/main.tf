locals {

  security_group_name = "${var.org_name}-${var.environment}-${var.sg_name}-sg"

  resource_tags = {
    Name    = local.security_group_name
    Service = var.sg_name
    Type    = "security-group"
  }

  tags = merge(
    var.tags,
    local.resource_tags
  )
}

resource "aws_security_group" "this" {

  name        = local.security_group_name
  description = "Security group for ${var.sg_name}"

  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}