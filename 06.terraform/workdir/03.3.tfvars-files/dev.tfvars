aws_region              = "us-east-1"
environment             = "dev"
ami_id                  = "ami-0f3caa1cf4417e51b"
instance_type           = "t3.micro"
instance_count          = 1
enable_monitoring       = false
app_server_name         = "dev-app-server"
app_security_group_name = "dev-app-sg"

allowed_ssh_cidr_blocks = ["10.0.0.0/24"]

common_tags = {
  Project = "Terraform-Demo"
  Env     = "Dev"
}