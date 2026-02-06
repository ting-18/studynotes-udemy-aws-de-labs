terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-west-2"  # use your ergion
}

#Create a budget
resource "aws_budgets_budget" "monthly_budget" {
    name = "monthly-budget"
    budget_type = "COST"
    limit_amount = "10"
    limit_unit = "USD"
    time_unit = "MONTHLY"
    time_period_start = "2026-02-01_00:00" #change date
    time_period_end = "2026-03-01_00:00" # change date
    notification {
      comparison_operator = "GREATER_THAN"
      threshold = 80
      threshold_type = "PERCENTAGE"
      notification_type = "FORECASTED"
      subscriber_email_addresses = ["tliu18@outlook.com"]  #use your subscriber_email_addresses
    }
} 

# Create an aws S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "aws-de-labs-bucket"  #Amazon S3 bucket names must be globally unique across all AWS accounts
  force_destroy = true #terraform destroy can delete a non-empty S3 bucket
  # By default, Terraform will not delete an S3 bucket if it contains any objects

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  # lifecycle {
  #   prevent_destroy = true # Comment out or remove this line if it exists
  # }
}





# Manage Redshift Serverless resources/ Create an namespace/workgroup 
# Define an IAM role that Redshift Serverless can assume
resource "aws_iam_role" "example" {
  name = "redshift-serverless-example-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach necessary policies to the role (e.g., S3 read-only access)
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Create a Redshift Serverless Namespace
resource "aws_redshiftserverless_namespace" "example" {
  namespace_name = "example-namespace"
  db_name        = "exampledb"
  admin_username = "admin"
  admin_user_password = var.db_password # Use a variable for sensitive data
  iam_roles      = [aws_iam_role.example.arn] # Associate the IAM role
}

# Create a Redshift Serverless Workgroup
resource "aws_redshiftserverless_workgroup" "example" {
  workgroup_name = "example-workgroup"
  namespace_name = aws_redshiftserverless_namespace.example.namespace_name
  base_capacity  = 4 # Minimum RPU capacity
  publicly_accessible = true
  # subnet_ids and security_group_ids should also be specified in a real scenario
}

# Output the endpoint address to connect to the database
output "redshift_serverless_endpoint" {
  value = aws_redshiftserverless_workgroup.example.endpoint[0].address
}