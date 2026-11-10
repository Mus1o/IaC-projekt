# Outputs visas i terminalen när "terraform apply" är klar

output "config_file" {
  value = local_file.config.filename
}

output "environment" {
  value = var.environment
}
