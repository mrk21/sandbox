variable "inputs" {
  type = object({
    app = string
    env = string
    public_subnet = object({
      id = string
    })
    security_group = object({
      bastion = object({
        id = string
      })
    })
    instance_profile = object({
      bastion = object({
        name = string
      })
    })
    key_pair = object({
      key_name = string
    })
    ssm_params = object({
      private_key = object({
        name = string
      })
    })
  })
}

locals {
  app              = var.inputs.app
  env              = var.inputs.env
  base_name        = "${local.app}-${local.env}"
  public_subnet    = var.inputs.public_subnet
  security_group   = var.inputs.security_group
  instance_profile = var.inputs.instance_profile
  key_pair         = var.inputs.key_pair
  ssm_params       = var.inputs.ssm_params
}
