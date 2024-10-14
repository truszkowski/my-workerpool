module "worker_pool" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2"

  configuration = <<-EOT
    export SPACELIFT_TOKEN="${spacelift_worker_pool.aws.config}"
    export SPACELIFT_POOL_PRIVATE_KEY="${base64encode(tls_private_key.main.private_key_pem)}"
  EOT

  max_size          = var.min_size
  min_size          = var.max_size
  ec2_instance_type = var.ec2_instance_type
  security_groups   = [aws_security_group.main.id]
  vpc_subnets       = module.vpc.private_subnets
  worker_pool_id    = spacelift_worker_pool.aws.id
  
  enable_autoscaling    = true
  autoscaler_s3_package = {
    bucket = aws_s3_bucket.autoscaler_binary.id
    key    = aws_s3_object.autoscaler_binary.id
  }

  spacelift_api_key_id       = var.spacelift_api_key_id
  spacelift_api_key_secret   = var.spacelift_api_key_secret
  spacelift_api_key_endpoint = var.spacelift_api_key_endpoint
}

resource "spacelift_worker_pool" "aws" {
  csr  = base64encode(tls_cert_request.main.cert_request_pem)
  name = "My WorkerPool (${random_string.suffix.id})"
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