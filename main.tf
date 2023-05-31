data "aws_iam_policy_document" "subscription" {
  count = length(var.subscription) >= 1 ? 1 : 0

  statement {
    actions   = ["sqs:SendMessage"]
    resources = [module.sqs.queue_arn]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.subscription_aws_account_id}:root"]
    }

    dynamic "condition" {
      for_each = var.subscription
      content {
        test     = "ArnEquals"
        values   = [for key in keys(aws_sns_topic_subscription.default) : aws_sns_topic_subscription.default[key].topic_arn]
        variable = "aws:SourceArn"
      }
    }
  }
}

module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "4.0.1"

  name = module.this.id

  create_queue_policy = true

  queue_policy_statements = {
    account = {
      actions = [
        "*",
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${module.this.aws_account_id}:root"]
        }
      ]
    }
  }

  source_queue_policy_documents = [try(data.aws_iam_policy_document.subscription[0].json, null)]

  create_dlq = var.dlq_enabled

  redrive_policy = {
    maxReceiveCount = var.dlq_max_receive_count
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
