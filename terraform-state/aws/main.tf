provider "aws" {
  shared_config_files = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

// Apply AFTER resources are deployed
# terraform {
#   backend "s3" {
#     bucket = "zztalk-demo-tf-state"
#     key = "zztalk-demo"
#     region = "us-west-2"
#     dynamodb_table = "terraform_locks"
#   }
# }