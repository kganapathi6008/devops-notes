org_name    = "myorg"
environment = "dev"
aws_region  = "us-east-1"

############################################################
# VPC
############################################################
vpc_name = "dev-vpc"
vpc_cidr = "10.0.0.0/16"
az_count = 3

############################################################
# key pairs
############################################################

key_pairs = {
  service-a = {}
  service-b = {}
}

############################################################
# SECURITY GROUPS
############################################################

security_groups = {

  global = {

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


  service-a = {

    ingress_rules = [

      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        description = "Service-A application port"
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


  service-b = {

    ingress_rules = [

      {
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        description = "Service-B application port"
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


  vault = {

    ingress_rules = [

      {
        from_port   = 8200
        to_port     = 8200
        protocol    = "tcp"
        description = "Vault access"
        cidr_blocks = ["10.0.0.0/16"]
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

############################################################
# EC2 INSTANCES
############################################################

ec2_instances = {

  service-a = {
    ami_id            = "ami-0f3caa1cf4417e51b"
    instance_type     = "t3.micro"
    instance_count    = 1
    enable_monitoring = false

    security_groups = [ "global", "service-a", "vault" ]
    key_pair        = "service-a"
  }

  service-b = {
    ami_id            = "ami-0f3caa1cf4417e51b"
    instance_type     = "t3.small"
    instance_count    = 2
    enable_monitoring = false

    security_groups = [ "global", "service-b", "vault" ]
    key_pair        = "service-b"
  }

}