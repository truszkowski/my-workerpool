variable "min_size" {
    type = number
    default = 1
}

variable "max_size" {
    type = number
    default = 3
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