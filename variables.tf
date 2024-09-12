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
