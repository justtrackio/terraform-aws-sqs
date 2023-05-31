module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.1"

  name = module.this.id

  create_queue_policy = true

  queue_policy_statements = {
    account = {
      sid = "AccountReadWrite"
      actions = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${module.this.aws_account_id}:root"]
        }
      ]
    }
  }

  create_dlq = var.dlq_enabled

  redrive_policy = {
    maxReceiveCount = var.dlq_max_receive_count
  }

  tags = module.this.tags
}

module "sqs_subscription" {
  for_each = var.subscription
  source   = "terraform-aws-modules/sqs/aws"
  version  = "4.0.1"

  name = module.this.id

  create = false

  create_queue_policy = true
  queue_policy_statements = {
    "each.value.topic_name" = {
      sid = "SubscriptionReadWrite"
      actions = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${var.subscription_aws_account_id}:root"]
        }
      ]
      condition = {
        test     = "ArnEquals"
        values   = "arn:aws:sns:${module.this.aws_region}:${var.subscription_aws_account_id}:${each.value.topic_name}"
        variable = "aws:SourceArn"
      }
    }
  }

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
