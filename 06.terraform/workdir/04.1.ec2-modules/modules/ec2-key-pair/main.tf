locals {

  key_name = "${var.org_name}-${var.environment}-${var.service_name}-key"

  key_directory = "${path.root}/keys/${var.environment}"

  key_file = "${local.key_directory}/${local.key_name}.pem"

  resource_tags = {
    Name = local.key_name
    Type = "key-pair"
  }

  tags = merge(
    var.tags,
    local.resource_tags
  )

}

resource "tls_private_key" "ssh_key" {

  algorithm = "RSA"
  rsa_bits  = 4096

  # lifecycle {
  #   prevent_destroy = true
  # }

}

resource "aws_key_pair" "generated" {

  key_name   = local.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = local.tags

  # lifecycle {
  #   prevent_destroy = true
  # }

}

resource "local_file" "private_key" {

  content         = tls_private_key.ssh_key.private_key_pem
  filename        = local.key_file
  file_permission = "0400"

  # lifecycle {
  #   ignore_changes = [content]
  # }

}