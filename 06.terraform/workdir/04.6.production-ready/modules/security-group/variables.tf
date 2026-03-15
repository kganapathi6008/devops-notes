variable "org_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "sg_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}