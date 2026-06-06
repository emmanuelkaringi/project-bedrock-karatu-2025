output "mysql_endpoint" {
  value     = aws_db_instance.mysql.address
  sensitive = true
}

output "postgres_endpoint" {
  value     = aws_db_instance.postgres.address
  sensitive = true
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.catalog.name
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "bedrock_dev_access_key_id" {
  value     = aws_iam_access_key.bedrock_dev_view.id
  sensitive = true
}

output "bedrock_dev_secret_access_key" {
  value     = aws_iam_access_key.bedrock_dev_view.secret
  sensitive = true
}