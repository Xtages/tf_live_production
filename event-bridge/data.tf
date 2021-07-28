data "terraform_remote_state" "xtages_sns_sqs" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production/sns-sqs"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ecs_customer_staging" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production/ecs/staging/customers"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ecs_customer_production" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production/ecs/production/customers"
    region = "us-east-1"
  }
}
