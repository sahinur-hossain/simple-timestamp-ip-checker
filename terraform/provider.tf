terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
# Povide secret and access keys
#  access_key  = ""
# secret_key  = ""
}
