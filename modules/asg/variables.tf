variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_security_group" {
  description = "Security group id to assign to instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-04a6f4d338851b383" # Ubuntu jammmy
}

variable "asg_prefix" {
  description = "Prefix for auto scaling group"
  type        = string
  default     = "sample-asg"
}

variable "asg_name" {
  description = "AutoScaling group subnets"
  type        = string
}

variable "asg_availability_zones" {
  description = "AutoScaling group availability zones"
  type        = list(string)
  default     = []
}

variable "asg_subnets" {
  description = "AutoScaling group subnets"
  type        = list(string)
  default     = []
}
