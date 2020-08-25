terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 3.3.0"
}

module "logging" {
  source = "../../../modules/logging"
  inputs = {
    app = "rails-structured-logging"
    env = "production"
  }
}

output "log_bucket" {
  value = module.logging.log_bucket
}
