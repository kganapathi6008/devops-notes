aws_region  = "us-east-1"
environment = "dev"
org_name   = "myorg"

security_group_rules = {
  internal_ssh = {
    port        = 22
    description = "SSH for internal communication"
    cidr_blocks = ["10.1.0.0/24"]
  }

  vpn_ssh = {
    port        = 22
    description = "SSH for VPN access"
    cidr_blocks = ["49.37.154.204/32"]
  }

  http = {
    port        = 80
    description = "HTTP traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  https = {
    port        = 443
    description = "HTTPS traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

ec2_instances = {
  service-a = {
    ami_id            = "ami-0f3caa1cf4417e51b"
    instance_type     = "t3.micro"
    instance_count    = 1
    enable_monitoring = false
  }

  service-b = {
    ami_id            = "ami-0f3caa1cf4417e51b"
    instance_type     = "t3.small"
    instance_count    = 2
    enable_monitoring = false
  }
}

