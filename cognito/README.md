## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cognito"></a> [cognito](#module\_cognito) | git::https://github.com/Xtages/tf_cognito.git?ref=v0.1.2 |  |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.xtages_ses](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `"606626603369"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | `"xtages.com"` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"production"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_user_pool_console_web_client_id"></a> [user\_pool\_console\_web\_client\_id](#output\_user\_pool\_console\_web\_client\_id) | n/a |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | n/a |
