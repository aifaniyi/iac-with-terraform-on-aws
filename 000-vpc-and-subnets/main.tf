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

# web server 1 (public subnet 1)
module "ec2_instance_subnet_1" {
  source                  = "../modules/ec2"
  instance_name           = "Web server 1"
  instance_security_group = module.security_groups.webserver_security_group
  instance_subnet         = aws_subnet.sample_public_subnet_1.id
}

# web server 2 (public subnet 2)
module "ec2_instance_subnet_2" {
  source                  = "../modules/ec2"
  instance_name           = "Web server 2"
  instance_security_group = module.security_groups.webserver_security_group
  instance_subnet         = aws_subnet.sample_public_subnet_2.id
}

# backend server 1 (private subnet 1)
module "ec2_instance_subnet_3" {
  source                  = "../modules/ec2"
  instance_name           = "Backend server 1"
  instance_security_group = module.security_groups.backend_server_security_group
  instance_subnet         = aws_subnet.sample_private_subnet_1.id
}

# backend server 2 (private subnet 2)
module "ec2_instance_subnet_4" {
  source                  = "../modules/ec2"
  instance_name           = "Backend server 2"
  instance_security_group = module.security_groups.backend_server_security_group
  instance_subnet         = aws_subnet.sample_private_subnet_2.id
}

