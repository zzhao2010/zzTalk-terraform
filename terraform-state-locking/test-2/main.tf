provider "aws" {
  shared_config_files = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
}

terraform {
  backend "pg" {}
}

resource "aws_instance" "test_2" {
  ami = "ami-0ceecbb0f30a902a6"
  instance_type =  "t2.micro"
  tags = {
    Name = "For test_2"
  }
}