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
| [aws_ecs_service.github-runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.runner_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.certs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.secretsmanager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_role_certs_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_role_secret_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.github_runner_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [github_actions_runner_group.runner_group](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/actions_runner_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecs_cluster.runner_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.certs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_object.certs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object) | data source |
| [github_actions_organization_registration_token.token](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/actions_organization_registration_token) | data source |
| [github_actions_registration_token.token](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/actions_registration_token) | data source |
| [github_organization.org](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/organization) | data source |
| [github_repository.repo](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/repository) | data source |
| [github_rest_api.org](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/rest_api) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certs"></a> [certs](#input\_certs) | n/a | <pre>object({<br>    bucket = string,<br>    key    = string<br>  })</pre> | `null` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of CPU units used by the task | `string` | `2048` | no |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The desired number of tasks for the ECS service | `number` | `3` | no |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | The ECS cluster name | `string` | n/a | yes |
| <a name="input_github_runner_permissions_arn"></a> [github\_runner\_permissions\_arn](#input\_github\_runner\_permissions\_arn) | n/a | `string` | `null` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname for the runner | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | The image to use for the runner | `string` | `"public.ecr.aws/h1g9x7n8/github-runner:1.22.31"` | no |
| <a name="input_log_group"></a> [log\_group](#input\_log\_group) | n/a | `string` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory (in MiB) used by the task | `string` | `4096` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace for the runner | `string` | n/a | yes |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | The list of security groups for the ECS service | <pre>object({<br>    security_groups  = optional(list(string), [])<br>    subnets          = optional(list(string), [])<br>    assign_public_ip = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | `null` | no |
| <a name="input_repo_org"></a> [repo\_org](#input\_repo\_org) | The organization of the repository | `string` | `null` | no |
| <a name="input_runner_group"></a> [runner\_group](#input\_runner\_group) | Configuration for the GitHub runner group, including name, visibility, selected workflows, selected repository IDs, and whether public repositories are allowed. | <pre>object({<br>    name                       = optional(string)<br>    visibility                 = optional(string, "selected")<br>    selected_workflows         = optional(list(string), [])<br>    selected_repository_ids    = optional(list(string), [])<br>    allows_public_repositories = optional(bool, false)<br>    create                     = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_runner_labels"></a> [runner\_labels](#input\_runner\_labels) | The labels for the runner | `list(string)` | n/a | yes |
| <a name="input_tag"></a> [tag](#input\_tag) | The tag for the runner | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_runner_group"></a> [runner\_group](#output\_runner\_group) | n/a |
| <a name="output_runner_task_definition"></a> [runner\_task\_definition](#output\_runner\_task\_definition) | n/a |
| <a name="output_token"></a> [token](#output\_token) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
<!-- END_TF_DOCS -->