locals {
  environment = {
    NAMESPACE     = var.namespace,
    HOSTNAME      = var.hostname,
    REPO_URL      = var.repo_url,
    ACCESS_TOKEN  = var.access_token,
    RUNNER_GROUP  = var.runner_group,
    RUNNER_LABELS = var.runner_labels,
  }
  ecs_environment = [for k, v in local.environment : { name = k, value = v }]
}

data "aws_region" "current" {}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${var.namespace}"
  retention_in_days = 90
}

resource "aws_ecs_task_definition" "runner_task_definition" {
  family                   = var.namespace
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name        = var.namespace
      image       = var.image
      essential   = true
      cpu         = 2048
      memory      = 4096
      environment = local.ecs_environment
      log_configuration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.function_log_group.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.tag
        }
      }
    }
  ])
}
