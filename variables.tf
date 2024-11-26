variable "alarm" {
  type = object({
    backlog_minutes     = optional(number, 5)
    datapoints_to_alarm = optional(number, 3)
    description         = optional(string, null)
    evaluation_periods  = optional(number, 3)
    period              = optional(number, 60)
    threshold           = optional(number, 0)
    priority            = optional(string, "warning")
  })
  description = "The details of the alarm such as datapoints to alarm, evaluation periods, backlog minutes, period, and threshold."
  default     = {}
}

variable "alarm_enabled" {
  type        = bool
  description = "Defines if the alarm should be created."
  default     = false
}

variable "alarm_topic_arn" {
  type        = string
  description = "The ARN of the SNS Topic used for notifying about alarm/ok messages."
  default     = null
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = null
}

variable "dlq_alarm" {
  type = object({
    backlog_minutes     = optional(number, 5)
    datapoints_to_alarm = optional(number, 3)
    description         = optional(string, null)
    evaluation_periods  = optional(number, 3)
    period              = optional(number, 60)
    threshold           = optional(number, 10)
    priority            = optional(string, "warning")
  })
  description = "The details of the DLQ alarm such as datapoints to alarm, evaluation periods, backlog minutes, period, and threshold."
  default     = {}
}

variable "dlq_alarm_enabled" {
  type        = bool
  description = "Defines if the DLQ alarm should be created."
  default     = true
}

variable "dlq_enabled" {
  type        = bool
  description = "Defines if Dead Letter Queue (DLQ) is enabled."
  default     = true
}

variable "dlq_max_receive_count" {
  type        = number
  description = "The maximum number of times a message can be received from the DLQ before it's discarded."
  default     = 5
}

variable "dlq_name" {
  type        = string
  description = "Sets a custom name for the to be created dlq."
  default     = null
}

variable "fifo_queue" {
  type        = bool
  description = "Boolean designating a FIFO queue"
  default     = false
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = null
}

variable "subscription" {
  type = map(object({
    aws_account_id = optional(string)
    topic_name     = string
    filter_policy  = optional(string)
  }))
  description = "The subscription details such as topic name and filter policy."
  default     = {}
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = null
}
