variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
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

variable "security_group_rules" {
  description = "Map of security group ingress rules"
  type = map(object({
    port        = number
    description = string
    cidr_blocks = list(string)
  }))
}