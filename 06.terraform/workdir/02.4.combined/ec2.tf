resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = local.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${local.key_name}.pem"
  file_permission = "0400"
}

resource "aws_instance" "ec2_instance" {
  count = var.instance_count

  ami           = var.ami_id
  instance_type = local.final_instance_type
  monitoring    = local.enable_detailed_monitoring
  key_name      = aws_key_pair.generated.key_name

  vpc_security_group_ids = [aws_security_group.application_sg.id]

  tags = merge(var.common_tags, {
    Name        = "${var.environment}-app-${count.index + 1}"
    Environment = var.environment
  })
}