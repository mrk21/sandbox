variable "inputs" {
  type = object({
    app = string
    env = string
    vpc = object({
      id = string
    })
  })
}

locals {
  app       = var.inputs.app
  env       = var.inputs.env
  base_name = "${local.app}-${local.env}"
  vpc       = var.inputs.vpc
}

output "sg" {
  value = {
    bastion = {
      id = aws_security_group.bastion.id
    }
    app = {
      id = aws_security_group.app.id
    }
    app_task = {
      id = aws_security_group.app_task.id
    }
    alb = {
      id = aws_security_group.alb.id
    }
    rds = {
      id = aws_security_group.rds.id
    }
    elasticache = {
      id = aws_security_group.elasticache.id
    }
  }
}
