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
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
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

module "eks" {
  source = "./modules/eks"

  cluster_name       = "project-bedrock-cluster"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  project_tag        = "karatu-2025-capstone"

  depends_on = [module.vpc]
}

module "security" {
  source = "./modules/security"

  vpc_id                = module.vpc.vpc_id
  node_security_group_id = module.eks.node_security_group_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  project_tag           = "karatu-2025-capstone"

  db_master_password = var.db_master_password
}

# Kubernetes provider config (for later)
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}