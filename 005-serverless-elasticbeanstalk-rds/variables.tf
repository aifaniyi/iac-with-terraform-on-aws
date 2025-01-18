variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

# RDS variables
variable "db_identifier" {
  description = "Database identifier"
  type        = string
  default     = "sample-database"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "authenticator"
}

variable "db_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
  default     = "postgres"
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
  default     = "postgres"
}

locals {
  app_env = {
    DB_HOST     = aws_db_instance.sample_database.address
    DB_NAME     = var.db_name
    DB_USER     = var.db_username
    DB_PORT     = aws_db_instance.sample_database.port
    DB_SSL_MODE = "true"
    DB_PASSWORD = var.db_password
    LOG_MODE    = "STDOUT"
  }
}
