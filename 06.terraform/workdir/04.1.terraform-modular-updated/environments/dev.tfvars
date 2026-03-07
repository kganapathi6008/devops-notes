aws_region  = "us-east-1"
environment = "dev"
org_name   = "myorg"

security_groups = {

  ec2 = {

    ingress_rules = [

      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        description = "SSH VPN access"
        cidr_blocks = [
          "49.37.154.204/32",
          "18.23.44.10/32"
        ]
      },

      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        description = "HTTP"
        cidr_blocks = ["0.0.0.0/0"]
      },

      {
        from_port   = 8080
        to_port     = 9000
        protocol    = "tcp"
        description = "Application ports"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ]

    egress_rules = [

      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "Allow all outbound"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ]

  }

  rds = {

    ingress_rules = [

      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "Postgres access"
        cidr_blocks = [
          "49.37.154.204/32",
          "18.23.44.10/32"
        ]
      }

    ]

    egress_rules = [

      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "Allow all outbound"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ]

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

