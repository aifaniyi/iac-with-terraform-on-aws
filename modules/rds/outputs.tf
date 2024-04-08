output "db_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.sample_db.username
  sensitive   = true
}

output "db_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.sample_db.address
  sensitive   = true
}

output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.sample_db.port
  sensitive   = true
}
