locals {

  computed_ec2_instances = flatten([

    for service_name, config in var.ec2_instances : [

      for i in range(config.instance_count) : {

        instance_key      = "${service_name}-${i}"
        service_name      = service_name
        index             = i
        ami_id            = config.ami_id
        instance_type     = config.instance_type
        enable_monitoring = config.enable_monitoring
        security_groups   = config.security_groups
        key_pair          = config.key_pair
        subnet_type       = config.subnet_type

        instance_name = "${var.org_name}-${service_name}-${var.environment}-${i}"

        resource_tags = {
          Name    = "${var.org_name}-${service_name}-${var.environment}-${i}"
          Service = service_name
          Type    = "ec2"
        }

      }

    ]

  ])

}

resource "aws_instance" "example" {

  for_each = {
    for instance in local.computed_ec2_instances :
    instance.instance_key => instance
  }

  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  monitoring    = each.value.enable_monitoring

  key_name = var.key_pairs[each.value.key_pair]

  subnet_id = each.value.subnet_type == "public" ? var.public_subnets[each.value.index % length(var.public_subnets)] : var.private_subnets[each.value.index % length(var.private_subnets)]

  associate_public_ip_address = each.value.subnet_type == "public"

  iam_instance_profile = var.iam_instance_profile

  vpc_security_group_ids = [
    for sg in each.value.security_groups :
    var.security_groups[sg]
  ]

  tags = merge(
    var.tags,
    each.value.resource_tags
  )

}