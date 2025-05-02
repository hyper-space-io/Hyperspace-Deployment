module "hyperspace" {
  source                = "github.com/hyper-space-io/Hyperspace-terraform-module"
  aws_region            = "REGION"
  domain_name           = "DOMAIN.com"
  environment           = "ENVIRONMENT"
  vpc_cidr              = "10.50.0.0/16"
  aws_account_id        = "AWS_ACCOUNT_ID"
  hyperspace_account_id = "HYPERSPACE_ACCOUNT_ID"

  argocd_config = {
    vcs = {
      organization = "<org>"
      repository   = "<repo>"
      gitlab = {
        enabled = true
      }
      github = {
        enabled = true
      }
    }
  }
}

terraform {
  backend "s3" {
    bucket       = "hyperspace-terraform-state-<random-string>"
    key          = "terraform.tfstate"
    region       = "REGION"
    encrypt      = true
    use_lockfile = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "REGION"
}