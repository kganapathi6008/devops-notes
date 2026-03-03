resource "aws_instance" "my_app_server" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  monitoring    = var.enable_monitoring

  vpc_security_group_ids = [aws_security_group.my_app_sg.id]

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.app_server_name}-${count.index + 1}"
      Environment = var.environment
    }
  )
}