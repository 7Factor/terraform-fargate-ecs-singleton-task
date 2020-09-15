output "task_definition_arn" {
  value       = aws_ecs_task_definition.main_task.arn
  description = "The arn of your task definition"
}