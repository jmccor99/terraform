resource "aws_sqs_queue" "this" {
  name = "myQueue"
  redrive_policy            = jsonencode(
    {
      deadLetterTargetArn = aws_sqs_queue.dlq.arn
      maxReceiveCount     = 4
    }
  )
  depends_on = [aws_sqs_queue.dlq] 
}

resource "aws_sqs_queue" "dlq" {
  name = "myQueue_dlq"

}

resource "aws_sns_topic" "this" {
  name = "myTopic"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.this.arn
}

resource "aws_sqs_queue_policy" "sns_to_sqs" {
  queue_url = aws_sqs_queue.this.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.this.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.this.arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "sns_to_sqs_dlq" {
  queue_url = aws_sqs_queue.dlq.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Second",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.dlq.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.this.arn}"
        }
      }
    }
  ]
}
POLICY
}