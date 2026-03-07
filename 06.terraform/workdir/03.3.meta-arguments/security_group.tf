resource "aws_security_group" "ec2_security_group" {
  name        = "${var.org_name}-${var.environment}-ec2-sg"
  description = "Security group for ${var.environment} EC2 instances"

  dynamic "ingress" {
    for_each = var.security_group_rules

    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
