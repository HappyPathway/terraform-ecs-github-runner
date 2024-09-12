locals {
  environment = {
    NAMESPACE     = var.namespace,
    HOSTNAME      = var.hostname,
    REPO_URL      = local.url,
    ACCESS_TOKEN  = local.token,
    RUNNER_GROUP  = var.runner_group == null ? "" : var.runner_group,
    RUNNER_LABELS = join(",", var.runner_labels),
  }
  ecs_environment = jsonencode([for k, v in local.environment : { name = k, value = v }])
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.namespace}-EcsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.namespace}-EcsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

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
  container_definitions = templatefile("${path.module}/container_definitions.json.tpl", {
    name        = var.namespace
    image       = var.image
    essential   = true
    cpu         = 2048
    memory      = 4096
    environment = tostring(local.ecs_environment)
    log_configuration = jsonencode({
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.function_log_group.name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = var.tag
      }
    })
  })
}
