// Globals
variable "vpc_id" {
  description = "The id of your vpc."
}

variable "cluster_name" {
  description = "The name of the cluster that we're deploying to."
}

// Task configuration
variable "app_name" {
  description = "The name of your app. This is used in the task configuration."
}

variable "cpu" {
  default     = 256
  description = "The number of cpu units used by the task."
}

variable "memory" {
  default     = 256
  description = "The amount (in MiB) of memory used by the task."
}

variable "container_definition" {
  description = "A container definitions JSON file."
}

variable "desired_task_count" {
  default     = 1
  description = "The desired number of tasks for the service to keep running. Defaults to one."
}

variable "service_deployment_maximum_percent" {
  default     = "200"
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Defaults to 200 percent, which should be used in 99% of cases to allow for proper green/blue."
}

variable "volumes" {
  type        = list(object({ name = string, host_path = string }))
  default     = []
  description = "A list of definitions to attach volumes to the ECS task."
}

variable "network_configurations" {
  type        = list(object({ subnets = list(string), security_groups = list(string), assign_public_ip = bool }))
  description = "A list of definitions to attach network configurations to the ECS task."
}

variable "load_balancers" {
  type        = list(object({ target_group_arn = string, container_name = string, container_port = number }))
  description = "A list of definitions to attach load balancers to the ECS task."
}

variable "task_role_arn" {
  default     = ""
  description = "The arn of the iam role you wish to pass to the ecs task containers."
}

variable "execution_role_arn" {
  default     = ""
  description = "This is required to run in fargate if you want to use the AWS cloudwatch log driver."
}