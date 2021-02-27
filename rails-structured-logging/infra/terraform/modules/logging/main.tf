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

output "log_bucket" {
  value = {
    bucket = aws_s3_bucket.log.bucket
  }
}
