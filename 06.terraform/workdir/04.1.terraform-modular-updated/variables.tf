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

variable "key_pairs" {
  description = "Key pairs to generate"
  type = map(object({}))
}

variable "ec2_instances" {

  description = "EC2 service definitions"

  type = map(object({
    ami_id            = string
    instance_type     = string
    instance_count    = number
    enable_monitoring = bool
    security_groups   = list(string)
    key_pair          = string
  }))

}

variable "security_groups" {

  description = "Security groups configuration"

  type = map(object({
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
      cidr_blocks = list(string)
    }))

    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      description = string
      cidr_blocks = list(string)
    }))
  }))

}