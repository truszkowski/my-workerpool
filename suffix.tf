# Used to randomize the resources names to avoid conflicts
resource "random_string" "suffix" {
  length  = 8
  lower   = false
  special = false
}
