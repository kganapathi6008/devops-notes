################ STRING ################

variable "region" {
  type = string
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod"
  }
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

################ NUMBER ################

variable "instance_count" {
  type = number

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 5
    error_message = "Instance count must be between 1 and 5"
  }
}

################ BOOLEAN ################

variable "enable_monitoring" {
  type = bool
}

################ LIST ################

variable "allowed_ssh_cidr_blocks" {
  type = list(string)
}

################ MAP ################

variable "common_tags" {
  type = map(string)
}
