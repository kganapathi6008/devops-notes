############################
# STRING VARIABLES
############################

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0f3caa1cf4417e51b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_server_name" {
  description = "Base name for the application server"
  type        = string
  default     = "my-app-server"
}

variable "app_security_group_name" {
  description = "Name of the application security group"
  type        = string
  default     = "my-app-sg"
}

############################
# NUMBER VARIABLE
############################

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 3

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 3
    error_message = "Instance count must be between 1 and 3."
  }
}

############################
# BOOLEAN VARIABLE
############################

variable "enable_monitoring" {
  description = "Enable detailed monitoring for EC2"
  type        = bool
  default     = true
}

############################
# LIST VARIABLE
############################

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to access SSH"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

############################
# MAP VARIABLE
############################

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "Terraform-Demo"
    Owner       = "Platform-Team"
    CostCenter  = "1001"
  }
}