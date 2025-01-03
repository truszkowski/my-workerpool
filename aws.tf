# All the resources below are created here so that this example is self-contained.
# They could be created elsewhere and the values would then be passed as variables
# and used by the "worker_pool" module above.

data "aws_vpc" "this" {
  default = true
}

data "aws_security_group" "this" {
  name   = "default"
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

data "aws_ami" "this" {
  most_recent = true
  name_regex  = "^spacelift-\\d{10}-arm64$"
  owners      = ["643313122712"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}


