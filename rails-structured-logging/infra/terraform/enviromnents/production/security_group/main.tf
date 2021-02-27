terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 3.3.0"
}

data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}

module "security_group" {
  source = "../../../modules/security_group"
  inputs = {
    app = "rails-structured-logging"
    env = "production"
    vpc = {
      id = data.terraform_remote_state.network.outputs.vpc.id
    }
  }
}

output "sg" {
  value = module.security_group.sg
}
