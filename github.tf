
resource "github_actions_runner_group" "runner_group" {
  count                      = var.runner_group.create ? 1 : 0
  name                       = var.runner_group.name
  visibility                 = var.runner_group.visibility
  selected_repository_ids    = var.runner_group.selected_repository_ids
  restricted_to_workflows    = var.runner_group.selected_workflows == [] ? false : true
  selected_workflows         = var.runner_group.selected_workflows
  allows_public_repositories = var.runner_group.allows_public_repositories
}

data "github_repository" "repo" {
  count     = var.repo_name == null ? 0 : 1
  full_name = "${var.repo_org}/${var.repo_name}"
}

data "github_actions_registration_token" "token" {
  count      = var.repo_name == null ? 0 : 1
  repository = one(data.github_repository.repo).name
}

data "github_actions_organization_registration_token" "token" {
  count = var.repo_name == null ? 1 : 0
}

data "github_organization" "org" {
  name = var.repo_org
}

locals {
  token = coalesce(
    one(data.github_actions_organization_registration_token.token),
    one(data.github_actions_registration_token.token)
  ).token
  url = var.repo_name == null ? "${var.server_url}/${var.repo_org}" : one(data.github_repository.repo).html_url
}
