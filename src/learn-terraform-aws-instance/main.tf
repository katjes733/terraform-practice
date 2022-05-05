terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "rearc_bloomberg"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-09d56f8956ab235b3"
  instance_type = "t3.micro"

  tags = {
    Name = "Mac_TfTestServer"
  }
}
