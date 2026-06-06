output "region" {
  value       = "us-east-1"
  description = "AWS Region"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS Cluster Endpoint"
}

output "cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS Cluster Name"
}

output "assets_bucket_name" {
  value       = "pending"
  description = "S3 Assets Bucket Name"
}