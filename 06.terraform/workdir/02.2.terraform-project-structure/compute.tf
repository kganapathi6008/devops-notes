resource "aws_instance" "web" {
  ami           = "ami-0f3caa1cf4417e51b"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "Terraform-Server"
  }
}