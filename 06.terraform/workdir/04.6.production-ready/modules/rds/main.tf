resource "aws_db_instance" "this" {

  for_each = var.rds_instances

  identifier = "${var.org_name}-${each.key}-${var.environment}"

  engine         = each.value.engine
  engine_version = each.value.engine_version
  instance_class = each.value.instance_class

  allocated_storage = each.value.allocated_storage

  db_name = each.value.db_name
  port    = each.value.port

  username = "postgres"
  password = "postgres123456"

  db_subnet_group_name = var.db_subnet_group_name

  vpc_security_group_ids = [
    for sg in each.value.security_groups :
    var.security_groups[sg]
  ]

  skip_final_snapshot = true

  tags = merge(
    var.tags,
    {
      Name = "${var.org_name}-${each.key}-${var.environment}"
      Type = "rds"
    }
  )
}