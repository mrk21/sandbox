resource "aws_ecs_cluster" "app" {
  name = "${local.base_name}-app"
}
