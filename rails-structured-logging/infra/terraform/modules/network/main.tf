variable "inputs" {
  type = object({
    app = string
    env = string
    vpc = object({
      cidr = string
    })
    public_subnets = list(object({
      cidr = string
      az   = string
    }))
  })
}

locals {
  app            = var.inputs.app
  env            = var.inputs.env
  base_name      = "${local.app}-${local.env}"
  vpc            = var.inputs.vpc
  public_subnets = var.inputs.public_subnets
}

output "vpc" {
  value = {
    id = aws_vpc.main.id
  }
}

output "public_subnets" {
  value = [
    for i, subnet in aws_subnet.public : {
      id = subnet.id
    }
  ]
}
