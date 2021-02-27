resource "aws_cloudwatch_log_group" "app_main" {
  name = "/${local.app}/${local.env}/app/main"

  tags = {
    Name = "${local.base_name}:logs:app_main"
    App  = local.app
    Env  = local.env
  }
}
