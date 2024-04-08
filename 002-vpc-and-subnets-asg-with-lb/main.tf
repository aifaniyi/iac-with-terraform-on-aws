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

module "webservers_lb" {
  source = "../modules/alb"

  alb_name                  = "webserver-alb"
  alb_listener_port         = "80"
  alb_listener_protocol     = "HTTP"
  alb_target_group_vpc_id   = aws_vpc.sample_vpc.id
  alb_target_group_protocol = "HTTP"
  alb_attachment_asg        = module.webserver_asg.asg_name
  alb_target_group_name     = "webserver-target-group"
  alb_security_groups       = [module.security_groups.webserver_security_group]
  alb_target_group_port     = "80"
  alb_subnets               = [aws_subnet.sample_public_subnet_1.id, aws_subnet.sample_public_subnet_2.id]
}
