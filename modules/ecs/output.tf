output "elb" {
  value = aws_elb.myapp_elb.dns_name
}

