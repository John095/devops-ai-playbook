variable "github_repo" {
  description = "GitHub repo allowed to assume this role, as \"org/repo\""
  type        = string
}

variable "role_name" {
  description = "Name of the IAM role GitHub Actions will assume"
  type        = string
  default     = "github-actions-ecr-push"
}

variable "repository_arns" {
  description = "ECR repository ARNs the role is allowed to push/pull"
  type        = list(string)
}
