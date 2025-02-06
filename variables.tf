variable "min_size" {
    type = number
    default = 1
}

variable "max_size" {
    type = number
    default = 5
}

variable "ec2_instance_type" {
    type = string
    default = "t3.micro"
}

variable "autoscaler_version" {
    description = "Version of the autoscaler to deploy"
    type        = string
    default     = "v0.3.0"
    nullable    = false
}

variable "autoscaler_architecture" {
    type        = string
    description = "Instruction set architecture of the autoscaler to use"
    default     = "amd64"
}

variable "spacelift_api_key_id" {
    type        = string
    description = "ID of the Spacelift API key to use"
}

variable "spacelift_api_key_secret" {
    type        = string
    sensitive   = true
    description = "Secret corresponding to the Spacelift API key to use"
}

variable "spacelift_api_key_endpoint" {
    type        = string
    description = "Full URL of the Spacelift API endpoint to use, eg. https://demo.app.spacelift.io"
}

variable "env" {
    type = string
    description = "env of the worker pool"
}
