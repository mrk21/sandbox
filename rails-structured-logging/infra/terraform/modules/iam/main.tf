variable "inputs" {
  type = object({
    app = string
    env = string
  })
}

locals {
  app       = var.inputs.app
  env       = var.inputs.env
  base_name = "${local.app}-${local.env}"
}

output "instance_profile" {
  value = {
    app = {
      name = aws_iam_instance_profile.app.name
    }
    bastion = {
      name = aws_iam_instance_profile.bastion.name
    }
  }
}
