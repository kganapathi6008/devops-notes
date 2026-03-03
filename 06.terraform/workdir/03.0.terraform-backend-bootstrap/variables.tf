variable "aws_region" {
  description = "AWS region where backend resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod, etc.)"
  type        = string
}

variable "project_name" {
  description = "Logical project or organization name"
  type        = string
}

variable "bucket_name_override" {
  description = "Optional custom bucket name. If null, a generated name will be used."
  type        = string
  default     = null
}

# NOTE:
# lifecycle.prevent_destroy cannot use variables because
# it must be known during configuration loading.
# So we DO NOT parameterize prevent_destroy.
# It will be hardcoded to true inside resources for safety.