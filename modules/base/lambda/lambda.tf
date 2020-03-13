resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_for_lambda" {
  name = "lambda-logs"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "test"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  filename      = "${path.module}/package.zip"
  publish       = true
}

resource "aws_cloudwatch_log_metric_filter" "test_lambda" {
  name           = "test_lambda_error"
  log_group_name = "/aws/lambda/test"
  pattern = "Error"

    metric_transformation {
    name      = "ErrorCount"
    namespace = "test_lambda"
    value     = "1"
  }
}

resource "aws_sns_topic" "alarms" {
  name = "test-alarms"
}

resource "aws_cloudwatch_metric_alarm" "test_lambda" {
  alarm_name          = "test_lambda"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorCount"
  namespace           = "test_lambda"
  period              = "10"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "test_lambda_error"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alarms.arn]
}

resource "aws_sns_topic_subscription" "pagerduty" {
  #endpoint               = "https://events.pagerduty.com/integration/09f194d2af3d47b392f907d698be37b0/enqueue"
  endpoint               = "https://events.pagerduty.com/integration/771d5066657c457ab89339757e5a1347/enqueue"
  endpoint_auto_confirms = true
  protocol               = "https"
  topic_arn              = aws_sns_topic.alarms.arn
}