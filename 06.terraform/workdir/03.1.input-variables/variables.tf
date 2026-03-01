variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default = "ami-0f3caa1cf4417e51b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_server_name" {
  description = "Name tag for the application server"
  type        = string
  default     = "my-app-server"
}

variable "app_security_group_name" {
  description = "Name of the application security group"
  type        = string
  default     = "my-app-sg"
}

variable "allowed_ssh_cidr_blocks" {
  description = "List of CIDR blocks allowed to access SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}