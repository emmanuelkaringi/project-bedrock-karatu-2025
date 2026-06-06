variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "node_security_group_id" {
  description = "EKS Node Group SG ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "project_tag" {
  description = "Project tag"
  type        = string
}

variable "db_master_username" {
  description = "Master username for RDS instances"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}

variable "db_master_password" {
  description = "Master password for RDS instances"
  type        = string
  sensitive   = true
}

variable "github_repo" {
  description = "GitHub repository in format owner/repo"
  type        = string
}