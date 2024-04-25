terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
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

# Used to randomize the resources names to avoid conflicts
resource "random_string" "suffix" {
  length  = 8
  lower   = false
  special = false
}

module "worker_pool" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2?ref=misc-improvements"

  configuration = <<-EOT
    export SPACELIFT_TOKEN="${spacelift_worker_pool.aws.config}"
    export SPACELIFT_POOL_PRIVATE_KEY="${base64encode(tls_private_key.main.private_key_pem)}"
  EOT

  max_size        = 1
  min_size        = 1
  security_groups = [aws_security_group.main.id]
  vpc_subnets     = module.vpc.private_subnets
  worker_pool_id  = spacelift_worker_pool.aws.id
}

# All the resources below are created here so that this example is self-contained.
# They could be created elsewhere and the values would then be passed as variables
# and used by the "worker_pool" module above.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  azs                = ["us-east-1a"]
  cidr               = "10.1.0.0/16"
  enable_nat_gateway = true
  name               = "worker-pool-example-${random_string.suffix.id}"
  private_subnets    = ["10.1.1.0/24"]
  public_subnets     = ["10.1.2.0/24"]
}

resource "aws_security_group" "main" {
  name        = "worker-pool-example-${random_string.suffix.id}"
  description = "Worker pool security group, with unrestricted egress and no ingress"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "spacelift_worker_pool" "aws" {
  csr  = base64encode(tls_cert_request.main.cert_request_pem)
  name = "AWS EC2 Worker Pool Example - ${random_string.suffix.id}"
}

# The private key and certificate are generated in Terraform for convenience in this demo.
# For improved security, we recommend that you create and manage them outside of Terraform.
# See https://docs.spacelift.io/concepts/worker-pools#setting-up.
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_cert_request" "main" {
  private_key_pem = tls_private_key.main.private_key_pem

  subject {
    organization = "Spacelift Examples"
  }
}
