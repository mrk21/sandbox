resource "aws_vpc" "main" {
  cidr_block           = local.vpc.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${local.base_name}:vpc:main"
    App  = local.app
    Env  = local.env
  }
}
