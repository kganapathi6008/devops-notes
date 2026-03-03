provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = "ami-0f3caa1cf4417e51b"
  instance_type = var.instance_type

  tags = {
    Name = "ec2-demo-instance"
  }
}