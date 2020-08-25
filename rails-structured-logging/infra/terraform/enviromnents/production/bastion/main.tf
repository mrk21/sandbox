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

data "terraform_remote_state" "security_group" {
  backend = "local"
  config = {
    path = "../security_group/terraform.tfstate"
  }
}

data "terraform_remote_state" "iam" {
  backend = "local"
  config = {
    path = "../iam/terraform.tfstate"
  }
}

data "terraform_remote_state" "secrets" {
  backend = "local"
  config = {
    path = "../secrets/terraform.tfstate"
  }
}

locals {
  network        = data.terraform_remote_state.network.outputs
  security_group = data.terraform_remote_state.security_group.outputs.sg
  iam            = data.terraform_remote_state.iam.outputs
  secrets        = data.terraform_remote_state.secrets.outputs
}

module "bastion" {
  source = "../../../modules/bastion"
  inputs = {
    app           = "rails-structured-logging"
    env           = "production"
    public_subnet = local.network.public_subnets.0
    security_group = {
      bastion = {
        id = local.security_group.bastion.id
      }
    }
    instance_profile = {
      bastion = {
        name = local.iam.instance_profile.bastion.name
      }
    }
    key_pair = {
      key_name = local.secrets.key_pair.main.key_name
    }
    ssm_params = {
      private_key = {
        name = local.secrets.ssm_params.key_pair.main.private.name
      }
    }
  }
}
