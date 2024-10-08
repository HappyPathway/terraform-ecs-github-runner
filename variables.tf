variable "hostname" {
  description = "The hostname for the runner"
  type        = string

  validation {
    condition     = length(var.hostname) > 0
    error_message = "The hostname variable must not be empty."
  }
}

variable "image" {
  description = "The image to use for the runner"
  type        = string
  default     = "public.ecr.aws/h1g9x7n8/github-runner:1.22.31"
  validation {
    condition     = length(var.image) > 0
    error_message = "The image variable must not be empty."
  }
}

variable "namespace" {
  description = "The namespace for the runner"
  type        = string

  validation {
    condition     = length(var.namespace) > 0
    error_message = "The namespace variable must not be empty."
  }
}

variable "runner_labels" {
  description = "The labels for the runner"
  type        = list(string)

  validation {
    condition     = length(var.runner_labels) > 0
    error_message = "The runner_labels variable must not be empty."
  }
}

variable "tag" {
  description = "The tag for the runner"
  type        = string

  validation {
    condition     = length(var.tag) > 0
    error_message = "The tag variable must not be empty."
  }
}

variable "cpu" {
  description = "The number of CPU units used by the task"
  type        = string
  default     = 2048

  validation {
    condition     = can(regex("^[0-9]+$", var.cpu))
    error_message = "The cpu variable must be a numeric string."
  }
}

variable "memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = string
  default     = 4096

  validation {
    condition     = can(regex("^[0-9]+$", var.memory))
    error_message = "The memory variable must be a numeric string."
  }
}

variable "repo_name" {
  description = "The name of the repository"
  type        = string
  default     = null

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.repo_name)) || var.repo_name == null
    error_message = "The repo_name variable must not be empty and can only contain alphanumeric characters, hyphens, and underscores."
  }
}

variable "repo_org" {
  description = "The organization of the repository"
  type        = string
  default     = null

  validation {
    condition     = var.repo_org == null || length(var.repo_org) > 0
    error_message = "The repo_org variable must be null or a non-empty string."
  }
}

variable "ecs_cluster" {
  description = "The ECS cluster name"
  type        = string

  validation {
    condition     = length(var.ecs_cluster) > 0
    error_message = "The ecs_cluster variable must not be empty."
  }
}

variable "desired_count" {
  description = "The desired number of tasks for the ECS service"
  type        = number
  default     = 3

  validation {
    condition     = var.desired_count > 0
    error_message = "The desired_count variable must be greater than 0."
  }
}


variable "runner_group" {
  description = "Configuration for the GitHub runner group, including name, visibility, selected workflows, selected repository IDs, and whether public repositories are allowed."
  default     = {}
  type = object({
    name                       = optional(string)
    visibility                 = optional(string, "selected")
    selected_workflows         = optional(list(string), [])
    restricted_to_workflows    = optional(bool, false)
    selected_repository_ids    = optional(list(string), [])
    allows_public_repositories = optional(bool, false)
    create                     = optional(bool, false)
  })

  validation {
    condition     = var.runner_group.name == null || can(regex("^[a-zA-Z0-9-_]+$", var.runner_group.name))
    error_message = "The runner_group variable must not be empty and can only contain alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = var.runner_group == {} || var.runner_group.allows_public_repositories == true || var.runner_group.allows_public_repositories == false
    error_message = "The allows_public_repositories variable must be a boolean."
  }

  validation {
    condition     = var.runner_group == {} || length(var.runner_group.selected_workflows) >= 0
    error_message = "The selected_workflows variable must be null or a list of strings."
  }

  validation {
    condition     = var.runner_group == {} || length(var.runner_group.selected_repository_ids) >= 0
    error_message = "The selected_repository_ids variable must be a list of strings."
  }

  validation {
    condition     = var.runner_group == {} || contains(["all", "selected"], var.runner_group.visibility)
    error_message = "The visibility variable must be either 'all' or 'selected'."
  }

  validation {
    condition     = var.runner_group == {} || var.runner_group.create == true || var.runner_group.create == false
    error_message = "The create_runner_group variable must be a boolean."
  }
}

variable "certs" {
  type = object({
    bucket = string,
    key    = string
  })

  default = null

  validation {
    condition     = var.certs == null || can(regex("^[a-zA-Z0-9-]+$", var.certs.bucket))
    error_message = "The certs_bucket variable must not be empty and can only contain alphanumeric characters and hyphens."
  }
  validation {
    condition     = var.certs == null || can(regex("^[a-zA-Z0-9-_/.]+$", var.certs.key))
    error_message = "The certs_key variable must not be empty and can only contain alphanumeric characters, hyphens, underscores, forward slashes, and dots."
  }
}

variable "network_configuration" {
  description = "The list of security groups for the ECS service"
  type = object({
    security_groups  = optional(list(string), [])
    subnets          = optional(list(string), [])
    assign_public_ip = optional(bool, false)
  })
  default = {}

  validation {
    condition     = var.network_configuration == {} || var.network_configuration.assign_public_ip == true || var.network_configuration.assign_public_ip == false
    error_message = "The assign_public_ip variable must be a boolean."
  }

  validation {
    condition     = var.network_configuration == {} || length(var.network_configuration.security_groups) == 0 || length([for sg in var.network_configuration.security_groups : can(regex("sg-[a-f0-9]{17}", sg))]) > 0
    error_message = "The security_groups variable contains an invalid security group ID."
  }

  validation {
    condition     = var.network_configuration == {} || length(var.network_configuration.subnets) == 0 || length([for subnet in var.network_configuration.subnets : can(regex("subnet-[a-f0-9]{8}", subnet))]) > 0
    error_message = "The subnets variable contains an invalid subnet ID."
  }
}

variable "github_runner_permissions_arn" {
  description = "The ARN of the IAM role with permissions for the GitHub runner"
  type        = string
  default     = null

  validation {
    condition     = var.github_runner_permissions_arn == null || can(regex("^arn:(aws|aws-us-gov|aws-cn):iam::[0-9]{12}:policy/.+$", var.github_runner_permissions_arn))
    error_message = "The github_runner_permissions_arn must be a valid IAM policy ARN in the correct partition (aws, aws-us-gov, aws-cn)."
  }
}

variable "log_group" {
  description = "The name of the CloudWatch log group"
  type        = string
  default     = null

  validation {
    condition     = var.log_group == null || can(regex("^[a-zA-Z0-9-_/.]+$", var.log_group))
    error_message = "The log_group must be a valid CloudWatch log group name containing only alphanumeric characters, hyphens, underscores, forward slashes, and periods."
  }
}

variable "server_url" {
  description = "The URL of the GitHub server"
  type        = string
  default     = ""

  validation {
    condition     = var.server_url == "" || can(regex("^(https?|git)://[a-zA-Z0-9-._~:/?#@!$&'()*+,;=%]+$", var.server_url))
    error_message = "The server_url must be a valid URL."
  }
}

variable "extra_environment_vars" {
  description = "Additional environment variables to inject into the container definition"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.extra_environment_vars : can(regex("^[a-zA-Z_][a-zA-Z0-9_]*$", k))])
    error_message = "All keys in extra_environment_vars must be valid environment variable names (alphanumeric characters and underscores, starting with a letter or underscore)."
  }

  validation {
    condition     = alltrue([for k, v in var.extra_environment_vars : can(regex("^[^\\x00-\\x1F\\x7F]*$", v))])
    error_message = "All values in extra_environment_vars must be valid strings without control characters."
  }
}
