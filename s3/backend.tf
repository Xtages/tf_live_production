terraform {
  backend "s3" {
    bucket  = "xtages-tfstate"
    key     = "tfstate/us-east-1/production/s3"
    region  = "us-east-1"
    encrypt = true
  }
}
