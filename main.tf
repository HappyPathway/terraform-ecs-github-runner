locals {
  environment = merge({
    NAMESPACE                = var.namespace,
    HOSTNAME                 = var.hostname,
    REPO_URL                 = local.url,
    ACCESS_TOKEN_SECRET_PATH = aws_secretsmanager_secret.secret.name,

    },
    var.runner_group.create ? {
      RUNNER_GROUP = var.runner_group.name,
    } : {},
    var.certs == null ? {} : {
      CERTS_PATH = "${var.certs.bucket}/${var.certs.key}",
    },
    {
      RUNNER_LABELS = join(",", var.runner_labels),
  })
  ecs_environment = jsonencode([for k, v in local.environment : { name = k, value = v }])
}


resource "aws_secretsmanager_secret" "secret" {
  name = "/github-runners/${var.namespace}/${var.hostname}"
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = local.token
  lifecycle {
    ignore_changes = [
      secret_string
    ]
  }
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  count = var.create_log_group ? 1 : 0
  name              = "/ecs-ghe-runners/${var.namespace}"
  retention_in_days = 90
}

locals {
  task_environment = templatefile("${path.module}/container_definitions.json.tpl", {
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

resource "aws_ecs_task_definition" "runner_task_definition" {
  family                   = var.namespace
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = local.task_environment
}
