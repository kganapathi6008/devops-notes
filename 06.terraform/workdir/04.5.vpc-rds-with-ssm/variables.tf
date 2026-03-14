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

## vpc variables

variable "az_count" {
  description = "Number of AZs"
  type        = number
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

## security group variables
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

## EC2 variables
variable "ec2_instances" {

  description = "EC2 service definitions"

  type = map(object({
    ami_id            = string
    instance_type     = string
    instance_count    = number
    enable_monitoring = bool
    security_groups   = list(string)
  }))

}

## RDS variables
variable "rds_instances" {

  type = map(object({
    engine            = string
    engine_version    = string
    instance_class    = string
    allocated_storage = number
    db_name           = string
    port              = number
    security_groups   = list(string)
  }))

}