data "aws_ecs_cluster" "target_cluster" {
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "main_task" {
  family                   = "${var.app_name}-tsk"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = var.container_definition

  task_role_arn      = var.task_role_arn
  execution_role_arn = var.execution_role_arn


  dynamic "volume" {
    for_each = [for v in var.volumes : {
      name      = v.name
      host_path = v.host_path
    }]

    content {
      name      = volume.value.name
      host_path = volume.value.host_path
    }
  }
}

resource "aws_ecs_service" "main_service" {
  name                       = "${var.app_name}-svc"
  task_definition            = aws_ecs_task_definition.main_task.arn
  cluster                    = data.aws_ecs_cluster.target_cluster.id
  desired_count              = var.desired_task_count
  launch_type                = "FARGATE"
  deployment_maximum_percent = var.service_deployment_maximum_percent

  dynamic "network_configuration" {
    for_each = [for n in var.network_configurations : {
      subnets          = n.subnets
      security_groups  = n.security_groups
      assign_public_ip = n.assign_public_ip
    }]

    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }

  dynamic "load_balancer" {
    for_each = [for l in var.load_balancers : {
      target_group_arn = l.target_group_arn
      container_name   = l.container_name
      container_port   = l.container_port
    }]

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
}
