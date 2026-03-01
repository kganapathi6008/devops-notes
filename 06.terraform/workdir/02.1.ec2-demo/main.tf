provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "ssh_sg" {
  name        = "ssh-sg"
  description = "Allow SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f3caa1cf4417e51b"           ## Note: Replace AMI ID with a valid AMI from your AWS region.
  instance_type = "t3.micro"                        ## check the AWS free tier eligibility for instance types.
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "Terraform-Server"
  }
}