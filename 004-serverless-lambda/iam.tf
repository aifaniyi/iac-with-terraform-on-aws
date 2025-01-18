# create IAM role for lambda function
resource "aws_iam_role" "persistence_lambda_role" {
  name = "persistence_lambda_role"

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

# create IAM policy to specify permissions available to the lambda function
resource "aws_iam_policy" "persistence_lambda_policy" {
  name        = "persistence_lambda_policy"
  description = "Policy to allow lambda read/write SQS, write to DynamoDB and log to CloudWatch"

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

# attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "lambda_sqs_role_policy" {
  role       = aws_iam_role.persistence_lambda_role.name
  policy_arn = aws_iam_policy.persistence_lambda_policy.arn
}

# connect lambda to source events from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.sample_sqs_queue.arn
  function_name    = aws_lambda_function.persistence_lambda_function.arn
}
