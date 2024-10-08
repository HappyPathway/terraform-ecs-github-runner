# valid_string_concat.tftest.hcl
variables {
  hostname  = "test-hostname"
  image     = "test-image"
  namespace = "test-namespace"
  log_group = "test-group"
  runner_group = {
    name   = "test-runner-group"
    create = false
  }
  runner_labels = ["test-runner-labels"]
  tag           = "test-tag"
  ecs_cluster   = "test-ecs-cluster"
  repo_org      = "HappyPathway"
}

run "valid_module_call" {

  command = plan

  assert {
    condition     = aws_iam_role.ecs_task_role.name == "test-hostname-task-role"
    error_message = "The ecs_task_role name is incorrect."
  }

  assert {
    condition     = aws_iam_role.ecs_task_execution_role.name == "test-hostname-task-execution-role"
    error_message = "The ecs_task_execution_role name is incorrect."
  }

  assert {
    condition     = aws_ecs_task_definition.runner_task_definition.family == "test-namespace-test-hostname"
    error_message = "The runner_task_definition family is incorrect."
  }
}
