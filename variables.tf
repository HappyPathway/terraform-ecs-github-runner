variable "access_token" {
  description = "The access token for authentication"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.access_token) > 0
    error_message = "The access_token variable must not be empty."
  }
}

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

variable "repo_url" {
  description = "The repository URL"
  type        = string

  validation {
    condition     = length(var.repo_url) > 0
    error_message = "The repo_url variable must not be empty."
  }
}

variable "runner_group" {
  description = "The runner group"
  type        = string

  validation {
    condition     = length(var.runner_group) > 0
    error_message = "The runner_group variable must not be empty."
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

variable "runner_group_visibility" {
  description = "The visibility of the runner group"
  type        = string
  default     = "private"

  validation {
    condition     = contains(["all", "selected"], var.runner_group_visibility)
    error_message = "The runner_group_visibility variable must be either 'all' or 'selected'."
  }
}

variable "selected_repository_ids" {
  description = "The list of repository IDs to which the runner group is restricted"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.selected_repository_ids) >= 0
    error_message = "The selected_repository_ids variable must be a list of strings."
  }
}

variable "selected_workflows" {
  description = "The list of workflows to which the runner group is restricted"
  type        = list(string)
  default     = null

  validation {
    condition     = var.selected_workflows == null || length(var.selected_workflows) >= 0
    error_message = "The selected_workflows variable must be null or a list of strings."
  }
}

variable "allows_public_repositories" {
  description = "Whether the runner group allows public repositories"
  type        = bool
  default     = false

  validation {
    condition     = var.allows_public_repositories == true || var.allows_public_repositories == false
    error_message = "The allows_public_repositories variable must be a boolean."
  }
}

variable "repo_name" {
  description = "The name of the repository"
  type        = string
  default     = null

  validation {
    condition     = var.repo_name == null || length(var.repo_name) > 0
    error_message = "The repo_name variable must be null or a non-empty string."
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

variable "runner_group_visbility" {
  description = "The visibility of the runner group"
  type        = string
  default     = "selected"

  validation {
    condition     = contains(["all", "selected"], var.runner_group_visbility)
    error_message = "The runner_group_visibility variable must be either 'all' or 'selected'."
  }
}
