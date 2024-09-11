# Required Variables:  [
#     "access_token",
#     "hostname",
#     "image",
#     "namespace",
#     "repo_url",
#     "runner_group",
#     "runner_labels",
#     "tag"
# ]
variable "access_token" {
  description = "The access token for authentication"
  type        = string
  sensitive   = true
}

variable "hostname" {
  description = "The hostname for the runner"
  type        = string
}

variable "image" {
  description = "The image to use for the runner"
  type        = string
}

variable "namespace" {
  description = "The namespace for the runner"
  type        = string
}

variable "repo_url" {
  description = "The repository URL"
  type        = string
}

variable "runner_group" {
  description = "The runner group"
  type        = string
}

variable "runner_labels" {
  description = "The labels for the runner"
  type        = list(string)
}

variable "tag" {
  description = "The tag for the runner"
  type        = string
}

variable "cpu" {
  description = "The number of CPU units used by the task"
  type        = string
  default     = 2048
}

variable "memory" {
  description = "The amount of memory (in MiB) used by the task"
  type        = string
  default     = 4096
}
