resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.ap-northeast-1.s3"
  route_table_ids = [aws_route_table.public.id]
}
