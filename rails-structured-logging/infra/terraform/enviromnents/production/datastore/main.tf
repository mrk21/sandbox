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

data "terraform_remote_state" "secrets" {
  backend = "local"
  config = {
    path = "../secrets/terraform.tfstate"
  }
}

locals {
  network        = data.terraform_remote_state.network.outputs
  security_group = data.terraform_remote_state.security_group.outputs.sg
  secrets        = data.terraform_remote_state.secrets.outputs
}

module "rds" {
  source = "../../../modules/rds"
  inputs = {
    app            = "rails-structured-logging"
    env            = "production"
    public_subnets = local.network.public_subnets
    security_group = {
      rds = {
        id = local.security_group.rds.id
      }
    }
    ssm_params = {
      rds = local.secrets.ssm_params.rds
    }
  }
}

module "elasticache" {
  source = "../../../modules/elasticache"
  inputs = {
    app            = "rails-structured-logging"
    env            = "production"
    public_subnets = local.network.public_subnets
    security_group = {
      elasticache = {
        id = local.security_group.elasticache.id
      }
    }
  }
}
