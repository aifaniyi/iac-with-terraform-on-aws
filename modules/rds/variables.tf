variable "db_identifier" {
  description = "Database identifier"
  type        = string
}

variable "db_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "db_security_groups" {
  description = "RDS subnet group"
  type        = list(string)
}

variable "db_subnet_group_subnet_ids" {
  description = "DB subnet group subnet ids"
  type        = list(string)
}
