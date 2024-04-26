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

########################
# create dynamo db table
########################
resource "aws_dynamodb_table" "sample_dynamodb_table" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"
  range_key    = "comment_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "comment_id"
    type = "N"
  }

  tags = {
    Name = local.table_name
  }
}

##################
# create SQS queue
##################
resource "aws_sqs_queue" "sample_sqs_queue" {
  name                      = local.sqs_queue_name
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Name = local.sqs_queue_name
  }
}

############################
# create lambda: persistence
############################
data "archive_file" "persistence_zip" {
  type        = "zip"
  source_dir  = "./lambda/nodejs/persistence"
  output_path = "./persistence.zip"
  excludes    = []
}

resource "aws_lambda_function" "persistence_lambda_function" {
  filename         = "persistence.zip"
  function_name    = "commentPersistenceFunction"
  role             = aws_iam_role.persistence_lambda_role.arn
  handler          = "main.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.persistence_zip.output_base64sha256

  environment {
    variables = {
      COMMENTS_DYNAMO_TABLE = aws_dynamodb_table.sample_dynamodb_table.arn
    }
  }
}

# create cloudwatch log group for lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.persistence_lambda_function.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

# create role for function
resource "aws_iam_role" "persistence_lambda_role" {
  name = "persistence-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# create policy to specify permissions available to the function
resource "aws_iam_policy" "lambda_dynamo_and_sqs_policy" {
  name        = "lambda_dynamo_and_sqs_policy"
  description = "Policy to allow lambda read SQS and write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:ConditionCheckItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Resource = "${aws_dynamodb_table.sample_dynamodb_table.arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:*"
        ]
        Resource = "${aws_sqs_queue.sample_sqs_queue.arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_role_policy" {
  role       = aws_iam_role.persistence_lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamo_and_sqs_policy.arn
  # policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

# connect lambda to source events from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.sample_sqs_queue.arn
  function_name    = aws_lambda_function.persistence_lambda_function.arn
}
