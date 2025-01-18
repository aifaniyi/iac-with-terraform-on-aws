# https://spacelift.io/blog/terraform-api-gateway

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

locals {
  table_name     = "sample_table"
  sqs_queue_name = "sample_sqs_queue"
}
