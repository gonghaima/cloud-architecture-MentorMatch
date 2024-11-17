terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"  # Adjust the version as needed
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}