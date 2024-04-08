resource "aws_db_subnet_group" "sample_db_subnet_group" {
  name       = var.db_identifier
  subnet_ids = var.db_subnet_group_subnet_ids

  tags = {
    Name = "Education"
  }
}

resource "aws_db_parameter_group" "sample_parameter_group" {
  name   = var.db_identifier
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "sample_db" {
  identifier             = var.db_identifier
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "16.2"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.sample_db_subnet_group.name
  vpc_security_group_ids = var.db_security_groups
  parameter_group_name   = aws_db_parameter_group.sample_parameter_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
