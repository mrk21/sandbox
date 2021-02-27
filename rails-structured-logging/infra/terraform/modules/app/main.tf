variable "inputs" {
  type = object({
    app = string
    env = string
    vpc = object({
      id = string
    })
    public_subnets = list(object({
      id = string
    }))
    security_group = object({
      app = object({
        id = string
      })
      app_task = object({
        id = string
      })
      alb = object({
        id = string
      })
    })
    instance_profile = object({
      app = object({
        name = string
      })
    })
    log_bucket = object({
      bucket = string
    })
    key_pair = object({
      key_name = string
    })
  })
}

locals {
  app              = var.inputs.app
  env              = var.inputs.env
  base_name        = "${local.app}-${local.env}"
  vpc              = var.inputs.vpc
  public_subnets   = var.inputs.public_subnets
  security_group   = var.inputs.security_group
  instance_profile = var.inputs.instance_profile
  log_bucket       = var.inputs.log_bucket
  key_pair         = var.inputs.key_pair
}
