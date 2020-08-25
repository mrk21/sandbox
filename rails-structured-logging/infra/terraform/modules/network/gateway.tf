resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.base_name}:igw:main"
    App  = local.app
    Env  = local.env
  }
}
