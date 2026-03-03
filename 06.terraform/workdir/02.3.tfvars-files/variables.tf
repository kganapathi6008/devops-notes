############################
# STRING VARIABLES
############################

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "app_server_name" {
  description = "Base name for the application server"
  type        = string
}

variable "app_security_group_name" {
  description = "Name of the application security group"
  type        = string
}

############################
# NUMBER VARIABLE
############################

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 5
    error_message = "Instance count must be between 1 and 5."
  }
}

############################
# BOOLEAN VARIABLE
############################

variable "enable_monitoring" {
  description = "Enable detailed monitoring for EC2"
  type        = bool
}

############################
# LIST VARIABLE
############################

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to access SSH"
  type        = list(string)
}

############################
# MAP VARIABLE
############################

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
}