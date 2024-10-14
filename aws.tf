# All the resources below are created here so that this example is self-contained.
# They could be created elsewhere and the values would then be passed as variables
# and used by the "worker_pool" module above.

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  azs                = ["us-east-1a"]
  cidr               = "10.1.0.0/16"
  enable_nat_gateway = true
  name               = "my-workerpool-${random_string.suffix.id}"
  private_subnets    = ["10.1.1.0/24"]
  public_subnets     = ["10.1.2.0/24"]
}

resource "aws_security_group" "main" {
  name        = "my-workerpool-${random_string.suffix.id}"
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


