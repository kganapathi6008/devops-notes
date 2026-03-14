variable "org_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "ec2_instances" {

  type = map(object({
  ami_id            = string
  instance_type     = string
  instance_count    = number
  enable_monitoring = bool
  security_groups   = list(string)
  key_pair          = string
  subnet_type       = string   # public or private
  }))

}

variable "security_groups" {
  type = map(string)
}

variable "key_pairs" {
  type = map(string)
}

variable "tags" {
  type = map(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}