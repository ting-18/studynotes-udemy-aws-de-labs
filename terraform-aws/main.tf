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
  region  = "us-east-1"
}

#Create a budget
resource "aws_budgets_budget" "monthly_budget" {
    name = "monthly-budget"
    budget_type = "COST"
    limit_amount = "10"
    limit_unit = "USD"
    time_unit = "MONTHLY"
    time_period_start = "2026-01-01_00:00"
    time_period_end = "2026-02-01_00:00"
    notification {
      comparison_operator = "GREATER_THAN"
      threshold = 80
      threshold_type = "PERCENTAGE"
      notification_type = "FORECASTED"
      subscriber_email_addresses = ["tliu18@outlook.com"]
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