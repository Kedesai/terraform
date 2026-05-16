# SNS Topic
resource "aws_sns_topic" "this" {
  name                          = var.topic_name
  display_name                  = var.display_name
  kms_master_key_id             = var.kms_master_key_id
  fifo_topic                    = var.fifo_topic
  content_based_deduplication   = var.content_based_deduplication
  delivery_policy               = var.delivery_policy

  application_success_feedback_role_arn    = var.application_success_feedback_role_arn
  application_success_feedback_sample_rate = var.application_success_feedback_sample_rate
  http_success_feedback_role_arn           = var.http_success_feedback_role_arn
  http_success_feedback_sample_rate        = var.http_success_feedback_sample_rate
  lambda_success_feedback_role_arn         = var.lambda_success_feedback_role_arn
  lambda_success_feedback_sample_rate      = var.lambda_success_feedback_sample_rate
  sqs_success_feedback_role_arn            = var.sqs_success_feedback_role_arn
  sqs_success_feedback_sample_rate         = var.sqs_success_feedback_sample_rate

  tags = merge(
    {
      Name        = var.topic_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "this" {
  for_each = { for sub in var.subscriptions : "${sub.protocol}_${md5(sub.endpoint)}" => sub }

  topic_arn             = aws_sns_topic.this.arn
  protocol              = each.value.protocol
  endpoint              = each.value.endpoint
  endpoint_id           = each.value.endpoint_id
  raw_message_delivery  = each.value.raw_message_delivery
  filter_policy         = each.value.filter_policy
  filter_policy_scope   = each.value.filter_policy_scope
}