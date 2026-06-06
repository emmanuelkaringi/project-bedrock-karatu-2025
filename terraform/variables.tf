variable "db_master_password" {
  description = "Master password for RDS databases"
  type        = string
  sensitive   = true
}