variable "inputs" {
  type = object({
    app = string
    env = string
    public_subnets = list(object({
      id = string
    }))
    security_group = object({
      elasticache = object({
        id = string
      })
    })
  })
}

locals {
  app            = var.inputs.app
  env            = var.inputs.env
  base_name      = "${local.app}-${local.env}"
  public_subnets = var.inputs.public_subnets
  security_group = var.inputs.security_group
}
