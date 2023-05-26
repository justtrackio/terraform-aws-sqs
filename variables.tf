variable "subscription" {
  type = map(object({
    topic_name    = string
    filter_policy = optional(string)
  }))
  description = ""
  default     = null
}

variable "subscription_aws_account_id" {
  type        = string
  description = ""
}

variable "dlq_enabled" {
  type        = bool
  description = ""
  default     = true
}

variable "dlq_max_receive_count" {
  type        = number
  description = ""
  default     = 5
}

variable "alarm" {
  type = object({
    datapoints_to_alarm = optional(number, 3)
    description         = optional(string, null)
    evaluation_periods  = optional(number, 3)
    backlog_minutes     = optional(number, 3)
    period              = optional(number, 60)
    threshold           = optional(number, 0)
  })
  description = ""
  default     = {}
}

variable "alarm_enabled" {
  type        = bool
  description = "Defines if alarm should be created"
  default     = false
}

variable "alarm_topic_arn" {
  type        = string
  description = "ARN of the SNS Topic used for notifying about alarm/ok messages."
  default     = null
}
