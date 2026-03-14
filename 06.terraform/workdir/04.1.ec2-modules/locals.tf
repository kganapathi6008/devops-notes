locals {

  common_tags = {
    Organization = var.org_name
    Environment  = var.environment
    ManagedBy    = "Terraform"
    Project      = "terraform-training"
  }

}