variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "org_name" {
  type        = string
  description = "Organization name used in resource naming"
}

variable "ec2_instances" {
  description = "Map of EC2 service definitions"
  type = map(object({
    ami_id            = string
    instance_type     = string
    instance_count    = number
    enable_monitoring = bool
  }))
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
}