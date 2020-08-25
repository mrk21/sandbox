resource "aws_ssm_parameter" "rds_user" {
  name        = "/${local.app}/${local.env}/rds/user"
  description = "RDS user"
  type        = "String"
  value       = local.params.rds.user

  tags = {
    Name = "${local.base_name}:ssm-param:rds_user"
    App  = local.app
    Env  = local.env
  }
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/${local.app}/${local.env}/rds/password"
  description = "RDS password"
  type        = "SecureString"
  value       = local.params.rds.password

  tags = {
    Name = "${local.base_name}:ssm-param:rds_user"
    App  = local.app
    Env  = local.env
  }
}
