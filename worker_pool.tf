module "worker_pool" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2?ref=v2.9.0"

  configuration = <<-EOT
    export SPACELIFT_TOKEN="${spacelift_worker_pool.aws.config}"
    export SPACELIFT_POOL_PRIVATE_KEY="${base64encode(tls_private_key.main.private_key_pem)}"
    export SPACELIFT_RUN_LOGS_ON_STANDARD_OUTPUT_ENABLED=true
  EOT

  min_size          = var.min_size
  max_size          = var.max_size
  ec2_instance_type = var.ec2_instance_type
  security_groups   = [data.aws_security_group.this.id]
  vpc_subnets       = data.aws_subnets.this.ids
  worker_pool_id    = spacelift_worker_pool.aws.id
  domain_name       = var.domain_name
  
  enable_autoscaling    = false
  #autoscaler_s3_package = {
  #  bucket = aws_s3_bucket.autoscaler_binary.id
  #  key    = aws_s3_object.autoscaler_binary.id
  #}

  spacelift_api_key_id       = var.spacelift_api_key_id
  spacelift_api_key_secret   = var.spacelift_api_key_secret
  spacelift_api_key_endpoint = var.spacelift_api_key_endpoint

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name = "sp5ft-${spacelift_worker_pool.aws.id}"
        Env = var.env
      }
    },
    {
      resource_type = "volume"
      tags = {
        Name = "sp5ft-${spacelift_worker_pool.aws.id}"
        Env = var.env
      }
    },
    {
      resource_type = "network-interface"
      tags = {
        Name = "sp5ft-${spacelift_worker_pool.aws.id}"
        Env = var.env
      }
    }
  ]
}

resource "spacelift_worker_pool" "aws" {
  csr      = base64encode(tls_cert_request.main.cert_request_pem)
  name     = "My WorkerPool (${random_string.suffix.id})"
  space_id = "root"
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
