aws_region              = "us-east-1"
environment             = "prod"
ami_id                  = "ami-0f3caa1cf4417e51b"
instance_type           = "t3.small"
instance_count          = 3
enable_monitoring       = true
app_server_name         = "prod-app-server"
app_security_group_name = "prod-app-sg"

allowed_ssh_cidr_blocks = ["10.0.1.0/24"]

common_tags = {
  Project = "Terraform-Demo"
  Env     = "Prod"
}