resource "aws_subnet" "public" {
  count = length(local.public_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnets[count.index].cidr
  availability_zone       = local.public_subnets[count.index].az
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.base_name}:subnet:public.${count.index + 1}"
    App  = local.app
    Env  = local.env
  }
}
