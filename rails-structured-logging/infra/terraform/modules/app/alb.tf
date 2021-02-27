resource "aws_lb" "app" {
  name                       = "rails-struct-log-${local.env}-app"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [local.security_group.app.id]
  subnets                    = local.public_subnets[*].id
  enable_deletion_protection = false

  access_logs {
    bucket  = local.log_bucket.bucket
    prefix  = "app-alb"
    enabled = true
  }

  tags = {
    Name = "${local.base_name}:alb:app"
    App  = local.app
    Env  = local.env
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "app" {
  name                 = "rails-struct-log-${local.env}-app"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = local.vpc.id
  deregistration_delay = 10

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = {
    Name = "${local.base_name}:target_grp:app"
    App  = local.app
    Env  = local.env
  }
}
