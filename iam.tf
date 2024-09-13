

# An error occurred (AccessDeniedException) when calling the GetSecretValue operation: User: arn:aws-us-gov:sts::229685449397:assumed-role/csvd-ghe-runner-EcsTaskRole/5e409858140d4e96ada845c950388fff is not authorized to perform: secretsmanager:GetSecretValue on resource: /github-runners/csvd-ghe-runner/csvd-gh-runner because no identity-based policy allows the secretsmanager:GetSecretValue action
resource "aws_iam_policy" "secretsmanager_policy" {
  name        = "secretsmanager-${var.namespace}-${var.hostname}"
  description = "Policy to allow secretsmanager:GetSecretValue on the specified secret"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "secretsmanager:GetSecretValue",
        Resource = aws_secretsmanager_secret.secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_secret_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.secretsmanager_policy.arn
}


# An error occurred (AccessDenied) when calling the GetObject operation: Access Denied
resource "aws_iam_policy" "certs_policy" {
  name        = "s3-certs-${var.namespace}-${var.hostname}"
  count       = var.certs == null ? 0 : 1
  description = "Policy to allow secretsmanager:GetSecretValue on the specified secret"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = one(data.aws_s3_bucket.certs).arn
      },
      {
        Effect   = "Allow",
        Action   = "s3:GetObject",
        Resource = one(data.aws_s3_object.certs).arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_certs_policy_attachment" {
  count      = var.certs == null ? 0 : 1
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = one(aws_iam_policy.certs_policy).arn
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
