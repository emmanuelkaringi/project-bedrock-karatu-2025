# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "project-bedrock-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL/PostgreSQL from EKS nodes"
    from_port       = 3306
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "project-bedrock-rds-sg"
    Project = var.project_tag
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "project-bedrock-db-subnet"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name    = "project-bedrock-db-subnet"
    Project = var.project_tag
  }
}

# Secrets Manager - MySQL
resource "aws_secretsmanager_secret" "mysql" {
  name = "project-bedrock/mysql-credentials"

  tags = {
    Project = var.project_tag
  }
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = var.db_master_password
    host     = aws_db_instance.mysql.address
    port     = 3306
    dbname   = "retail_mysql"
  })
}

# Secrets Manager - PostgreSQL
resource "aws_secretsmanager_secret" "postgres" {
  name = "project-bedrock/postgres-credentials"

  tags = {
    Project = var.project_tag
  }
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = var.db_master_password
    host     = aws_db_instance.postgres.address
    port     = 5432
    dbname   = "retail_postgres"
  })
}

# RDS MySQL
resource "aws_db_instance" "mysql" {
  identifier = "project-bedrock-mysql"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retail_mysql"
  username = var.db_master_username
  password = var.db_master_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot     = true
  backup_retention_period = 7

  tags = {
    Name    = "project-bedrock-mysql"
    Project = var.project_tag
  }
}

# RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier = "project-bedrock-postgres"

  engine            = "postgres"
  engine_version    = "18"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retail_postgres"
  username = var.db_master_username
  password = var.db_master_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot     = true
  backup_retention_period = 7

  tags = {
    Name    = "project-bedrock-postgres"
    Project = var.project_tag
  }
}

# DynamoDB Table
resource "aws_dynamodb_table" "catalog" {
  name         = "project-bedrock-catalog"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name    = "project-bedrock-catalog"
    Project = var.project_tag
  }
}