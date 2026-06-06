output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "region" {
  value       = "us-east-1"
  description = "AWS Region"
}

# Placeholders — we'll add more as we build
output "cluster_endpoint" {
  value       = "pending"
  description = "EKS Cluster Endpoint"
}

output "cluster_name" {
  value       = "pending"
  description = "EKS Cluster Name"
}

output "assets_bucket_name" {
  value       = "pending"
  description = "S3 Assets Bucket Name"
}