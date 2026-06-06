terraform {
  backend "s3" {
    bucket  = "project-bedrock-tfstate-alt-soe-025-4126"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "karatu-2025-capstone"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name    = "project-bedrock-vpc"
  project_tag = "karatu-2025-capstone"
}