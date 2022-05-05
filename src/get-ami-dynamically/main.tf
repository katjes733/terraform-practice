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

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

locals {
  amis = [data.aws_ssm_parameter.ami.value, data.aws_ami.ami.id]
}

resource "aws_instance" "app_server" {
  count = length(local.amis)

  ami           = local.amis[count.index]
  instance_type = "t3.micro"

  tags = {
    Name = "Mac_TfTestServer${sum([count.index, 1])}"
  }
}