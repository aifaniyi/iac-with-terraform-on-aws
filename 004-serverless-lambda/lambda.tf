#####################################
# create lambda function: persistence
# the lambda function "persistence" would consume messages
# from SQS and persist them to DynamoDB
# 
# The function needs 
# 1. access to SQS to read messages
# 2. access to DynamoDB to write messages
# 3. access to CloudWatch to log messages
#####################################
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


#####################################
# create lambda function: collector
# the lambda function "collector" would consume messages
# from SQS and persist them to DynamoDB
# 
# The function needs 
# 1. access to SQS to write messages
# 2. access to DynamoDB to read commments
# 3. access to CloudWatch to log messages
#####################################
data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "./lambda/nodejs/collector"
  output_path = "./collector.zip"
  excludes    = []
}

resource "aws_lambda_function" "collector_lambda_function" {
  filename         = "collector.zip"
  function_name    = "commentCollectorFunction"
  role             = aws_iam_role.persistence_lambda_role.arn # reuse persistence arn
  handler          = "main.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.collector_zip.output_base64sha256

  environment {
    variables = {
      COMMENTS_DYNAMO_TABLE = aws_dynamodb_table.sample_dynamodb_table.arn
    }
  }
}

resource "aws_api_gateway_resource" "sample_api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.sample_api_gateway.id
  parent_id   = aws_api_gateway_rest_api.sample_api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "sample_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.sample_api_gateway.id
  resource_id   = aws_api_gateway_resource.sample_api_gateway_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sample_collector_lambda_function_integration" {
  rest_api_id = aws_api_gateway_rest_api.sample_api_gateway.id
  resource_id = aws_api_gateway_method.sample_api_gateway_method.resource_id
  http_method = aws_api_gateway_method.sample_api_gateway_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.collector_lambda_function.invoke_arn
}

