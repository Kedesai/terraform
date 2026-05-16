# SQS Queue
resource "aws_sqs_queue" "this" {
  name                       = var.queue_name
  fifo_queue                 = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  kms_master_key_id          = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  policy                     = var.policy

  dynamic "redrive_policy" {
    for_each = var.redrive_policy_dead_letter_target_arn != null && var.redrive_policy_max_receive_count != null ? [1] : []
    content {
      dead_letter_target_arn = var.redrive_policy_dead_letter_target_arn
      max_receive_count      = var.redrive_policy_max_receive_count
    }
  }

  tags = merge(
    {
      Name        = var.queue_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}