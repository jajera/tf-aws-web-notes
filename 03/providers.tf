terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "terraform_remote_state" "state1" {
  backend = "local"

  config = {
    path = "../01/terraform.tfstate"
  }
}

data "terraform_remote_state" "state2" {
  backend = "local"

  config = {
    path = "../02/terraform.tfstate"
  }
}
