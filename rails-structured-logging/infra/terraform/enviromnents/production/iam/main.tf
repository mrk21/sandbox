terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 3.3.0"
}

module "iam" {
  source = "../../../modules/iam"
  inputs = {
    app = "rails-structured-logging"
    env = "production"
  }
}

output "instance_profile" {
  value = module.iam.instance_profile
}
