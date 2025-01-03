terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.82.1"
    }

    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 0.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "spacelift" {
}
