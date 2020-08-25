terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "~> 3.3.0"
}

module "network" {
  source = "../../../modules/network"
  inputs = {
    app = "rails-structured-logging"
    env = "production"
    vpc = {
      cidr = "10.1.0.0/16"
    }
    public_subnets = [
      { az = "ap-northeast-1d", cidr = "10.1.0.0/20" },
      { az = "ap-northeast-1c", cidr = "10.1.16.0/20" },
    ]
  }
}

output "vpc" {
  value = module.network.vpc
}
output "public_subnets" {
  value = module.network.public_subnets
}
