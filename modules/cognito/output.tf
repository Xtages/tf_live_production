output "prod_user_pool_id" {
  value = aws_cognito_user_pool.prod_user_pool.id
}
output "prod_user_pool_console_web_client_id" {
  value = aws_cognito_user_pool_client.prod_user_pool_console_web_client.id
}
