
resource "github_actions_runner_group" "example" {
  count                      = var.runner_group == null && var.create_runner_group ? 0 : 1
  name                       = var.namespace
  visibility                 = var.runner_group_visibility
  selected_repository_ids    = var.selected_repository_ids
  restricted_to_workflows    = var.selected_workflows == [] ? false : true
  selected_workflows         = var.selected_workflows
  allows_public_repositories = var.allows_public_repositories
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

data "github_rest_api" "org" {
  endpoint = "orgs/${data.github_organization.org.name}"
}

locals {
  token = coalesce(
    one(data.github_actions_organization_registration_token.token),
    one(data.github_actions_registration_token.token)
  ).token
  url = var.repo_name == null ? jsondecode(data.github_rest_api.org.body).html_url : one(data.github_repository.repo).html_url
}
