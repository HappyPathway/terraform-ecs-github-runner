data "aws_ecs_cluster" "runner_cluster" {
  cluster_name = var.ecs_cluster
}

resource "aws_ecs_service" "github-runner" {
  name            = "${var.namespace}-${var.hostname}"
  cluster         = data.aws_ecs_cluster.runner_cluster.id
  task_definition = aws_ecs_task_definition.runner_task_definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  dynamic "network_configuration" {
    for_each = var.network_configuration == null ? [] : [var.network_configuration]
    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }
}
