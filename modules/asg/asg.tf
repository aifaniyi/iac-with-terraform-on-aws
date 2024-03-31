resource "aws_launch_template" "sample_asg_launch_template" {
  name_prefix            = var.asg_prefix
  image_id               = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.instance_security_group]
}

resource "aws_autoscaling_group" "sample_asg" {
  name = var.asg_name
  # availability_zones   = var.asg_availability_zones
  desired_capacity     = 2
  max_size             = 6
  min_size             = 2
  health_check_type    = "EC2"
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = var.asg_subnets

  launch_template {
    id      = aws_launch_template.sample_asg_launch_template.id
    version = "$Latest"
  }
}
