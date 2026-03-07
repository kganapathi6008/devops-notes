variable "org_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ingress_rules" {
  description = "Security group ingress rules"

  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "Security group egress rules"

  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)
  }))
}