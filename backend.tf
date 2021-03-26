terraform {
  backend "s3" {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/staging"
    region = "us-east-1"
  }
}