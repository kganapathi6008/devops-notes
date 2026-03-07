variable "org_name" { type = string }
variable "environment" { type = string }
variable "ec2_instances" {
  type = map(object({
    ami_id            = string
    instance_type     = string
    instance_count    = number
    enable_monitoring = bool
  }))
}

variable "security_group_id" {
  type = string
}