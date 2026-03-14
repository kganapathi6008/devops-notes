variable "org_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "rds_instances" {

  type = map(object({
    engine            = string
    engine_version    = string
    instance_class    = string
    allocated_storage = number
    db_name           = string
    port              = number
    security_groups   = list(string)
  }))

}

variable "db_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = map(string)
}

variable "db_subnet_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}