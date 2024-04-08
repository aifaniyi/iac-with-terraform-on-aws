resource "aws_lb" "sample_alb" {
  name            = var.alb_name
  subnets         = var.alb_subnets
  security_groups = var.alb_security_groups

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_listener" "sample_alb_listener" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol

  default_action {
    target_group_arn = aws_lb_target_group.sample_alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "sample_listener_rule" {
  depends_on   = [aws_lb_target_group.sample_alb_target_group]
  listener_arn = aws_lb_listener.sample_alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_target_group" "sample_alb_target_group" {
  name     = var.alb_target_group_name
  port     = var.alb_target_group_port
  protocol = var.alb_target_group_protocol
  vpc_id   = var.alb_target_group_vpc_id
  tags = {
    name = var.alb_target_group_name
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = var.alb_target_group_port
  }
}

resource "aws_autoscaling_attachment" "sample_aws_autoscaling_attachment" {
  lb_target_group_arn    = aws_lb_target_group.sample_alb_target_group.arn
  autoscaling_group_name = var.alb_attachment_asg
}
