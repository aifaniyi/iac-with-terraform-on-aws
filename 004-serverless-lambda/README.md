# serverless

SQS -> lambda -> dynamodb

```bash
aws sqs send-message --queue-url http://localhost:19324/queue/queue-name --message-body file://./message.json --region=eu-west-3
```
