resource "aws_key_pair" "main" {
  key_name   = "${local.base_name}-main"
  public_key = file(local.key_pair.main.public)
}

resource "aws_ssm_parameter" "key_pair_main_private" {
  name        = "/${local.app}/${local.env}/key_pair/main/private"
  description = "main key pair private key"
  type        = "SecureString"
  value       = file(local.key_pair.main.private)

  tags = {
    Name = "${local.base_name}:ssm-param:key_pair_main_private"
    App  = local.app
    Env  = local.env
  }
}
