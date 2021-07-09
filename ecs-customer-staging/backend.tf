terraform {
  backend "s3" {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production/ecs/staging/customers"
    region = "us-east-1"
    encrypt = true
  }
}
