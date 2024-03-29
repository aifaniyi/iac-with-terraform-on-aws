output "webserver_security_group" {
  description = "Security group for web servers"
  value       = aws_security_group.webserver_security_group.id
}

output "backend_server_security_group" {
  description = "Security group for backend servers"
  value       = aws_security_group.backend_server_security_group.id
}
