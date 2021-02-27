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

data "terraform_remote_state" "logging" {
  backend = "local"
  config = {
    path = "../logging/terraform.tfstate"
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
  logging        = data.terraform_remote_state.logging.outputs
  secrets        = data.terraform_remote_state.secrets.outputs
}

module "app" {
  source = "../../../modules/app"
  inputs = {
    app            = "rails-structured-logging"
    env            = "production"
    vpc            = local.network.vpc
    public_subnets = local.network.public_subnets
    security_group = {
      app = {
        id = local.security_group.app.id
      }
      app_task = {
        id = local.security_group.app_task.id
      }
      alb = {
        id = local.security_group.alb.id
      }
    }
    instance_profile = {
      app = {
        name = local.iam.instance_profile.app.name
      }
    }
    log_bucket = {
      bucket = local.logging.log_bucket.bucket
    }
    key_pair = {
      key_name = local.secrets.key_pair.main.key_name
    }
  }
}
