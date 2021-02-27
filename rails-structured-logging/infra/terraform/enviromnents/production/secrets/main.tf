variable "RDS_USER" { type = string }
variable "RDS_PASSWORD" { type = string }

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 3.3.0"
}

locals {
  secrets_path = abspath("${path.module}/../../../../secrets")
}

module "secrets" {
  source = "../../../modules/secrets"
  inputs = {
    app = "rails-structured-logging"
    env = "production"
    key_pair = {
      main = {
        private = "${local.secrets_path}/rails-structured-logging.pem"
        public  = "${local.secrets_path}/rails-structured-logging.pem.pub"
      }
    }
    params = {
      rds = {
        user     = var.RDS_USER
        password = var.RDS_PASSWORD
      }
    }
  }
}

output "key_pair" {
  value = module.secrets.key_pair
}

output "ssm_params" {
  value = module.secrets.ssm_params
}
