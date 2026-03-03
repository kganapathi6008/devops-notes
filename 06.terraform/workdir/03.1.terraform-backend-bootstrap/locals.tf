# Get AWS Account ID (used for global uniqueness)
data "aws_caller_identity" "current" {}

# Random suffix to guarantee globally unique S3 bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  # Standard naming prefix
  name_prefix = "${var.project_name}-${var.environment}"

  # S3 bucket must be globally unique across ALL AWS accounts
  bucket_name = var.bucket_name_override != null ? var.bucket_name_override : "${local.name_prefix}-tfstate-${data.aws_caller_identity.current.account_id}-${random_id.bucket_suffix.hex}"

  # DynamoDB table name (only needs account-level uniqueness)
  dynamodb_table_name = "${local.name_prefix}-tflock"
}