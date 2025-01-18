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
