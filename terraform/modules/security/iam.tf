# IAM User for Developer Read-Only Access
resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"
  tags = {
    Project = var.project_tag
  }
}

# Attach AWS ReadOnlyAccess policy
resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# S3 PutObject permission for assets bucket (needed for Phase 4.5 verification)
resource "aws_iam_user_policy" "s3_put" {
  name = "bedrock-assets-put"
  user = aws_iam_user.bedrock_dev_view.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::bedrock-assets-*",
          "arn:aws:s3:::bedrock-assets-*/*"
        ]
      }
    ]
  })
}

# Access keys for kubectl
resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}