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
  jumpbox   = {}
}

############################################################
# SECURITY GROUPS
############################################################

security_groups = {

  jumpbox = {

    ingress_rules = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        description = "SSH access"
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

  rds = {

    ingress_rules = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "PostgreSQL access from VPC"
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

  monitoring = {

    ingress_rules = [
      {
        from_port   = 9187
        to_port     = 9187
        protocol    = "tcp"
        description = "Postgres exporter monitoring"
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

  jumpbox = {
    ami_id            = "ami-0f3caa1cf4417e51b"
    instance_type     = "t3.micro"
    instance_count    = 1
    enable_monitoring = false
    security_groups   = ["jumpbox"]
    key_pair          = "jumpbox"
    subnet_type       = "public"
  }

  service-a = {
    ami_id            = "ami-0f3caa1cf4417e51b"
    instance_type     = "t3.micro"
    instance_count    = 1
    enable_monitoring = false
    security_groups   = ["service-a"]
    key_pair          = "service-a"
    subnet_type       = "private"
  }

}

############################################################
# RDS
############################################################

rds_instances = {

  postgres-db-1 = {
    engine            = "postgres"
    engine_version    = "15"
    instance_class    = "db.t4g.micro"
    allocated_storage = 20
    db_name           = "appdb1"
    port              = 5432
    security_groups = [ "rds", "monitoring" ]
  }

  # postgres-db-2 = {
  #   engine            = "postgres"
  #   engine_version    = "15"
  #   instance_class    = "db.t4g.micro"
  #   allocated_storage = 20
  #   db_name           = "appdb2"
  #   port              = 5432
  #   security_groups = [ "rds", "monitoring" ]
  # }

}