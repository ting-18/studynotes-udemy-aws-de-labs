variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "aws-labs-datasets-bucket"
}
# Amazon S3 bucket names must be globally unique across all AWS accounts

variable "bucket_name_airflow" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "aws-labs-airflow-bucket"
}
# Amazon S3 bucket names must be globally unique across all AWS accounts

