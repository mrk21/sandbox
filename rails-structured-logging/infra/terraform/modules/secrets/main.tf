variable "inputs" {
  type = object({
    app = string
    env = string
    key_pair = object({
      main = object({
        private = string
        public  = string
      })
    })
    params = object({
      rds = object({
        user     = string
        password = string
      })
    })
  })
}

locals {
  app       = var.inputs.app
  env       = var.inputs.env
  base_name = "${local.app}-${local.env}"
  key_pair  = var.inputs.key_pair
  params    = var.inputs.params
}

output "key_pair" {
  value = {
    main = {
      key_name = aws_key_pair.main.key_name
    }
  }
}

output "ssm_params" {
  value = {
    key_pair = {
      main = {
        private = {
          name = aws_ssm_parameter.key_pair_main_private.name
        }
      }
    }
    rds = {
      user = {
        name = aws_ssm_parameter.rds_user.name
      }
      password = {
        name = aws_ssm_parameter.rds_password.name
      }
    }
  }
}
