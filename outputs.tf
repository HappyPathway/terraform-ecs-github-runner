output "runner_group" {
  value = github_actions_runner_group.runner_group
}

output "url" {
  value = local.url
}

output "token" {
  value     = local.token
  sensitive = true
}

output "runner_task_definition" {
  value = aws_ecs_task_definition.runner_task_definition
}
