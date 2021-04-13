data "aws_ssm_parameter" "db_password" {
  name = "/db/${var.db_name}/${var.env}/password"
  with_decryption = true
}
