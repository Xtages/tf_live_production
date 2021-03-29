variable "env" {
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_subnets" {
  type = list
}

variable "vpc_id" {
}

variable "ssh_pub_key_name" {
  default = "xtages.pub"
}