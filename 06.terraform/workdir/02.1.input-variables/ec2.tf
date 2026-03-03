resource "aws_instance" "my_app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.my_app_sg.id]

  tags = {
    Name = var.app_server_name
  }
}