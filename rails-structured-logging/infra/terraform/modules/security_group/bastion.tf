resource "aws_security_group" "bastion" {
  name   = "${local.base_name}-bastion"
  vpc_id = local.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.base_name}:sg:bastion"
    App  = local.app
    Env  = local.env
  }
}
