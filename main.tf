module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.1"

  # This creates both the queue and the dead letter queue together

  name = module.this.id

  ## Policy
  ## Not required - just showing example
  #create_queue_policy = true
  #queue_policy_statements = {
  #  account = {
  #    sid = "AccountReadWrite"
  #    actions = [
  #      "sqs:SendMessage",
  #      "sqs:ReceiveMessage",
  #    ]
  #    principals = [
  #      {
  #        type        = "AWS"
  #        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  #      }
  #    ]
  #  }
  #}

  create_dlq = var.dlq_enabled

  redrive_policy = {
    maxReceiveCount = var.dlq_max_receive_count
  }

  ## Dead letter queue policy
  ## Not required - just showing example
  #create_dlq_queue_policy = true
  #dlq_queue_policy_statements = {
  #  account = {
  #    sid = "AccountReadWrite"
  #    actions = [
  #      "sqs:SendMessage",
  #      "sqs:ReceiveMessage",
  #    ]
  #    principals = [
  #      {
  #        type        = "AWS"
  #        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  #      }
  #    ]
  #  }
  #}

  tags = module.this.tags
}

resource "aws_sns_topic_subscription" "default" {
  for_each                        = var.subscription
  topic_arn                       = "arn:aws:sns:${module.this.aws_region}:${var.subscription_aws_account_id}:${each.value.topic_name}"
  confirmation_timeout_in_minutes = "1"
  endpoint_auto_confirms          = "false"
  protocol                        = "sqs"
  endpoint                        = module.sqs.queue_arn
  filter_policy                   = each.value.filter_policy
}
