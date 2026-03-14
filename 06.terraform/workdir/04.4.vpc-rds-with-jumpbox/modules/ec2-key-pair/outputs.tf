output "key_name" {
  value = aws_key_pair.generated.key_name
}

output "key_file" {
  value = local.key_file
}