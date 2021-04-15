variable "env" {}

variable "db_name" {}

variable "db_user" {}

variable "vpc_id" {}

variable "app" {}

variable "private_subnets" {}

variable "storage" {}

variable "db_instance_class" {}

variable "retention" {
  description = "Days of retention that we want for the DB"
}
