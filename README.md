# terraform-ecs-github-runner
Terraform Module

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.function_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.github-runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.runner_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [github_actions_runner_group.example](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_runner_group) | resource |
| [aws_ecs_cluster.runner_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [github_actions_organization_registration_token.token](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/actions_organization_registration_token) | data source |
| [github_actions_registration_token.token](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/actions_registration_token) | data source |
| [github_organization.org](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/organization) | data source |
| [github_repository.repo](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/repository) | data source |
| [github_rest_api.org](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/rest_api) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allows_public_repositories"></a> [allows\_public\_repositories](#input\_allows\_public\_repositories) | Whether the runner group allows public repositories | `bool` | `false` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of CPU units used by the task | `string` | `2048` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The desired number of tasks for the ECS service | `number` | `3` | no |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | The ECS cluster name | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname for the runner | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | The image to use for the runner | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory (in MiB) used by the task | `string` | `4096` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the runner | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | `null` | no |
| <a name="input_repo_org"></a> [repo\_org](#input\_repo\_org) | The organization of the repository | `string` | `null` | no |
| <a name="input_runner_group"></a> [runner\_group](#input\_runner\_group) | The runner group | `string` | `null` | no |
| <a name="input_runner_group_visibility"></a> [runner\_group\_visibility](#input\_runner\_group\_visibility) | The visibility of the runner group | `string` | `"private"` | no |
| <a name="input_runner_labels"></a> [runner\_labels](#input\_runner\_labels) | The labels for the runner | `list(string)` | n/a | yes |
| <a name="input_selected_repository_ids"></a> [selected\_repository\_ids](#input\_selected\_repository\_ids) | The list of repository IDs to which the runner group is restricted | `list(string)` | `[]` | no |
| <a name="input_selected_workflows"></a> [selected\_workflows](#input\_selected\_workflows) | The list of workflows to which the runner group is restricted | `list(string)` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets for the ECS service | `list(string)` | n/a | yes |
| <a name="input_tag"></a> [tag](#input\_tag) | The tag for the runner | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->