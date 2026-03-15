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
# SECURITY GROUPS
############################################################

security_groups = {

  alb = {

    ingress_rules = [

      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        description = "HTTP access from internet"
        cidr_blocks = ["0.0.0.0/0"]
      },

      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        description = "HTTPS access from internet"
        cidr_blocks = ["0.0.0.0/0"]
      }

    ]

    egress_rules = []
  }

  service-a = {

    ingress_rules = [
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        description = "Service-A application port"
        source_sg_names = ["alb"]
      }
    ]

    egress_rules = [

      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        description = "Access PostgreSQL"
        source_sg_names = ["rds"]
      },

      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        description = "Internet access"
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
        description = "Service-A access to PostgreSQL"
        source_sg_names = ["service-a"]
      }

    ]

    egress_rules = []
  }

  monitoring = {

    ingress_rules = [

      {
        from_port   = 9187
        to_port     = 9187
        protocol    = "tcp"
        description = "Postgres exporter monitoring"
        cidr_blocks = ["vpc"]
      }

    ]

    egress_rules = []
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

    security_groups = [ "service-a" ]
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