variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "eu-west-3"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_security_group" {
  description = "Security group id to assign to instance"
  type        = string
}

variable "instance_subnet" {
  description = "Security group id to assign to instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-04a6f4d338851b383" # Ubuntu jammmy
}
