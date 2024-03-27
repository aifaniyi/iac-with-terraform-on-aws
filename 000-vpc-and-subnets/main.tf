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

module "webserver_security_group" {
  source = "../modules/security_group"
  vpc_id = aws_vpc.sample_vpc.id
}

module "ec2_instance_subnet_1" {
  source                  = "../modules/ec2"
  instance_name           = "Web server 1"
  instance_security_group = module.webserver_security_group.webserver_security_group
  instance_subnet         = aws_subnet.sample_public_subnet_1.id
}

module "ec2_instance_subnet_2" {
  source                  = "../modules/ec2"
  instance_name           = "Web server 2"
  instance_security_group = module.webserver_security_group.webserver_security_group
  instance_subnet         = aws_subnet.sample_public_subnet_2.id
}
