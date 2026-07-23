variable "github_repo" {
  description = "GitHub repo allowed to assume this role, as \"org/repo\" (used for tagging/readability only)"
  type        = string
}

variable "github_owner_id" {
  description = "Numeric GitHub user/org ID (immutable, survives renames) - find via `gh api /users/<owner> --jq .id`"
  type        = string
}

variable "github_repo_id" {
  description = "Numeric GitHub repo ID (immutable, survives renames) - find via `gh api /repos/<owner>/<repo> --jq .id`"
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
