#########################
# ALB parameters
#########################
variable "alb_name" {
  description = "ALB name"
  type        = string
}

variable "alb_subnets" {
  description = "ALB subnets"
  type        = list(string)
  default     = []
}

variable "alb_security_groups" {
  description = "ALB security groups"
  type        = list(string)
  default     = []
}

#########################
# listener parameters
#########################
variable "alb_listener_port" {
  description = "ALB listener port"
  type        = string
  default     = "80"
}

variable "alb_listener_protocol" {
  description = "ALB listener protocol"
  type        = string
  default     = "HTTP"
}

#########################
# target group parameters
#########################
variable "alb_target_group_name" {
  description = "ALB target group name"
  type        = string
}

variable "alb_target_group_port" {
  description = "ALB target group port"
  type        = string
  default     = "80"
}

variable "alb_target_group_protocol" {
  description = "ALB target group protocol"
  type        = string
  default     = "HTTP"
}

variable "alb_target_group_vpc_id" {
  description = "ALB target group vpc id"
  type        = string
}

#########################
# ASG parameters
#########################
variable "alb_attachment_asg" {
  description = "ASG to which ALB will be attached"
  type        = string
}
