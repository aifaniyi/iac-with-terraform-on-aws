# Reference: https://medium.com/@gaston.acosta/deploy-any-containerized-app-on-aws-elasticbeanstalk-with-github-actions-and-terraform-3b587bbb15aa
provider "aws" {
  region = var.aws_region
}

resource "aws_db_instance" "sample_database" {
  identifier              = var.db_identifier
  instance_class          = "db.t3.micro"
  allocated_storage       = 5
  engine                  = "postgres"
  storage_type            = "gp2"
  engine_version          = "16.3"
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.postgres16"
  backup_retention_period = 0 # no backup fo database
  skip_final_snapshot     = true
}

resource "aws_iam_role" "beanstalk_role" {
  name = "beanstalk_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Description: Provide the instances in your web server environment access to upload log files to Amazon S3.
resource "aws_iam_role_policy_attachment" "beanstalk_log_attach" {
  role       = aws_iam_role.beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "beanstalk_iam_instance_profile" {
  name = "beanstalk_iam_instance_profile"
  role = aws_iam_role.beanstalk_role.name
}

resource "aws_s3_bucket" "sample_app_s3_bucket" {
  bucket = "sample-app-s3-bucket"

  tags = {
    Name = "Application S3 bucket"
  }
}

resource "aws_s3_object" "app_deployment_script" {
  bucket = aws_s3_bucket.sample_app_s3_bucket.id
  key    = "Dockerrun.aws.json"
  source = "Dockerrun.aws.json"

  etag = filemd5("Dockerrun.aws.json")
}

resource "aws_elastic_beanstalk_application" "sample_app" {
  name        = "sample_web_app"
  description = "Sample Web API application"
}

resource "aws_elastic_beanstalk_environment" "sample_app_dev_env" {
  name         = "sample-app-dev-env"
  application  = aws_elastic_beanstalk_application.sample_app.name
  cname_prefix = "sample-app"

  solution_stack_name = "64bit Amazon Linux 2023 v4.3.2 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_iam_instance_profile.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "True"
  }

  dynamic "setting" {
    for_each = local.app_env
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }
}

resource "aws_elastic_beanstalk_application_version" "sample_app_version" {
  name        = "sample_app_version"
  application = aws_elastic_beanstalk_application.sample_app.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.sample_app_s3_bucket.id
  key         = aws_s3_object.app_deployment_script.id
}
