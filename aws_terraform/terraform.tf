# Provider設定とBackend設定
provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

terraform {
  backend "s3" {
    bucket = "hikosaburou-aws-h4b-terraform-tfstate"
    key    = "main/"
    region = "ap-northeast-1"
  }
}