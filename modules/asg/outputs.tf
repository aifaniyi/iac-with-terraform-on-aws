output "asg_name" {
  description = "ASG name"
  value       = aws_autoscaling_group.sample_asg.name
}
