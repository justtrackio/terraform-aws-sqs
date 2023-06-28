locals {
  alarm_description = var.alarm.description != null ? var.alarm.description : "SQS Queue Metrics: https://${module.this.aws_region}.console.aws.amazon.com/sqs/v2/home?region=${module.this.aws_region}#/queues/https%3A%2F%2Fsqs.${module.this.aws_region}.amazonaws.com%2F${module.this.aws_account_id}%2F${module.sqs.queue_name}"
}

resource "aws_cloudwatch_metric_alarm" "backlog" {
  count = module.this.enabled && var.alarm_enabled ? 1 : 0

  alarm_description = jsonencode(merge({
    Severity    = "warning"
    Description = local.alarm_description
  }, module.this.tags, module.this.additional_tag_map))
  alarm_name          = "${module.sqs.queue_name}-backlog"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = var.alarm.datapoints_to_alarm
  evaluation_periods  = var.alarm.evaluation_periods
  threshold           = var.alarm.threshold
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "visible"
    return_data = false

    metric {
      dimensions = {
        QueueName = module.sqs.queue_name
      }
      metric_name = "ApproximateNumberOfMessagesVisible"
      namespace   = "AWS/SQS"
      period      = var.alarm.period
      stat        = "Sum"
    }
  }

  metric_query {
    id          = "incoming"
    return_data = false

    metric {
      dimensions = {
        QueueName = module.sqs.queue_name
      }
      metric_name = "NumberOfMessagesSent"
      namespace   = "AWS/SQS"
      period      = var.alarm.period
      stat        = "Sum"
    }
  }

  metric_query {
    id          = "delayed"
    return_data = false

    metric {
      dimensions = {
        QueueName = module.sqs.queue_name
      }
      metric_name = "ApproximateNumberOfMessagesDelayed"
      namespace   = "AWS/SQS"
      period      = var.alarm.period
      stat        = "Sum"
    }
  }

  metric_query {
    id          = "deleted"
    return_data = false

    metric {
      dimensions = {
        QueueName = module.sqs.queue_name
      }
      metric_name = "NumberOfMessagesDeleted"
      namespace   = "AWS/SQS"
      period      = var.alarm.period
      stat        = "Sum"
    }
  }

  metric_query {
    expression  = "visible - delayed + incoming - (deleted * ${var.alarm.backlog_minutes})"
    id          = "backlog"
    label       = "visible - delayed + incoming - (deleted * ${var.alarm.backlog_minutes})"
    return_data = true
  }

  alarm_actions = var.alarm_topic_arn != null ? [var.alarm_topic_arn] : []
  ok_actions    = var.alarm_topic_arn != null ? [var.alarm_topic_arn] : []

  tags = module.this.tags
}
