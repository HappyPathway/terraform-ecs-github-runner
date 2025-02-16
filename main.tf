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
    },
  var.extra_environment_vars)
  ecs_environment = jsonencode([for k, v in local.environment : { name = k, value = v }])
}

resource "random_pet" "pet" {}
resource "aws_secretsmanager_secret" "secret" {
  name = "/github-runners/${var.namespace}/${var.hostname}-${random_pet.pet.id}"
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = local.token
}


locals {
  task_environment = templatefile("${path.module}/container_definitions.json.tpl", {
    name        = var.hostname
    image       = var.image
    essential   = true
    cpu         = 2048
    memory      = 4096
    environment = tostring(local.ecs_environment)
    log_configuration = jsonencode({
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.log_group
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = var.tag
      }
    })
  })
}

resource "aws_ecs_task_definition" "runner_task_definition" {
  family                   = "${var.namespace}-${var.hostname}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = local.task_environment
}
