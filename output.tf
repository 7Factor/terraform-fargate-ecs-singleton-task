output "task_definition_arn" {
  value       = aws_ecs_task_definition.main_task.arn
  description = "The arn of your task definition"
}

output "task_definition_family" {
  value       = aws_ecs_task_definition.main_task.family
  description = "The family of your task definition"
}

output "task_definition_revision" {
  value       = aws_ecs_task_definition.main_task.revision
  description = "The revision of your task definition"
}
