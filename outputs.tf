output "suffix" {
    value     = random_string.suffix.id
    sensitive = false
}

output "test" {
    value     = worker_pool.autoscaling_group_name
    sensitive = false
}