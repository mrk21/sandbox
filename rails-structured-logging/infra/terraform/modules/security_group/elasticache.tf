resource "aws_security_group" "elasticache" {
  name   = "${local.base_name}-elasticache"
  vpc_id = local.vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.base_name}:sg:elasticache"
    App  = local.app
    Env  = local.env
  }
}
