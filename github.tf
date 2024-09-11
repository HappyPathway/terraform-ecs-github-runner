
resource "github_actions_runner_group" "example" {
  name                       = var.namespace
  visibility                 = var.runner_group_visbility
  selected_repository_ids    = var.selected_repository_ids
  restricted_to_workflows    = var.selected_workflows == null ? false : true
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
  org_token  = one(data.github_actions_organization_registration_token.token).token
  repo_token = one(data.github_actions_registration_token.token).token
  token      = var.repo_name == null ? local.org_token : local.repo_token
  repo_url   = var.repo_name == null ? one(data.github_rest_api.org).url : one(data.github_repository.repo).html_url
}
