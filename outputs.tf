output "sqs_queue_url" {
  value       = module.sqs.queue_url
  description = "queue url of the main sqs queue"
}
output "sqs_queue_arn" {
  value       = module.sqs.queue_arn
  description = "queue arn of the main sqs queue"
}

output "sqs_queue_name" {
  value       = module.sqs.queue_name
  description = "queue name of the main sqs queue"
}

output "dlq_queue_url" {
  value       = module.sqs.dead_letter_queue_url
  description = "queue url of the dead letter sqs queue"
}

output "dlq_queue_arn" {
  value       = module.sqs.dead_letter_queue_arn
  description = "queue arn of the dead letter sqs queue"
}

output "dlq_queue_name" {
  value       = module.sqs.dead_letter_queue_name
  description = "queue name of the dead letter sqs queue"
}
