output "instance_ids" {
  value = aws_instance.ec2_instance[*].id
}

output "security_group_id" {
  value = aws_security_group.application_sg.id
}

output "instance_private_ips" {
  value = aws_instance.ec2_instance[*].private_ip
}

output "instance_private_dns" {
  value = aws_instance.ec2_instance[*].private_dns
}

output "instance_public_ips" {
  value = aws_instance.ec2_instance[*].public_ip
}

output "instance_public_dns" {
  value = aws_instance.ec2_instance[*].public_dns
}

output "instance_arns" {
  value = aws_instance.ec2_instance[*].arn
}

output "instance_region" {
  value = var.region
}

output "instance_availability_zones" {
  value = aws_instance.ec2_instance[*].availability_zone
}

output "instance_tags" {
  value = aws_instance.ec2_instance[*].tags
}

output "instance_types" {
  value = aws_instance.ec2_instance[*].instance_type
}

output "instance_vpc" {
  value = aws_security_group.application_sg.vpc_id
}

output "instance_subnet_ids" {
  value = aws_instance.ec2_instance[*].subnet_id
}

output "instance_root_block_devices" {
  value = aws_instance.ec2_instance[*].root_block_device
}

#############################
# Sensitive Output
#############################

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}