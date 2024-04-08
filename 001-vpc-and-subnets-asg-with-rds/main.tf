terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

module "security_groups" {
  source = "../modules/security_group"
  vpc_id = aws_vpc.sample_vpc.id
}

module "webserver_asg" {
  source = "../modules/asg"

  instance_security_group = module.security_groups.webserver_security_group
  asg_name                = "webserver-asg"
  asg_prefix              = "webserver"
  asg_availability_zones  = var.aws_availability_zones
  asg_subnets             = [aws_subnet.sample_public_subnet_1.id, aws_subnet.sample_public_subnet_2.id]
}

module "database_servers" {
  source = "../modules/rds"

  db_password                = var.db_password
  db_identifier              = "backend-database"
  db_security_groups         = [module.security_groups.database_server_security_group]
  db_subnet_group_subnet_ids = [aws_subnet.sample_private_subnet_1.id, aws_subnet.sample_private_subnet_2.id]
  db_username                = "sample"
}
