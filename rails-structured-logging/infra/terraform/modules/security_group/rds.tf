resource "aws_security_group" "rds" {
  name   = "${local.base_name}-rds"
  vpc_id = local.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
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
    Name = "${local.base_name}:sg:rds"
    App  = local.app
    Env  = local.env
  }
}
