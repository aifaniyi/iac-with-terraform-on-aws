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
