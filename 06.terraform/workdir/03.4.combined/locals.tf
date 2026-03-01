locals {
  # Conditional instance sizing only
  final_instance_type = var.environment == "prod" ? "t3.medium" : var.instance_type

  # Monitoring only in prod
  enable_detailed_monitoring = var.enable_monitoring && var.environment == "prod"

  key_name = "${var.environment}-ssh-key"
}