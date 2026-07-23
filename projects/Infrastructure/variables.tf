variable "region" {
  description = "The name of the region"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Value"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}


variable "cluster_name" {
  description = "The name of the Kubernetes Cluster"
  type        = string
}

variable "node_group_name" {
  type        = string
  description = "EKS node group name"
}

variable "instance_types" {
  type        = list(string)
  description = "Instance types for worker nodes (t3.medium, t3.large)"
}

variable "capacity_type" {
  type        = string
  description = "ON_DEMAND or SPOT"
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "Minimum number of  worker nodes"
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "disk_size" {
  type = number
}

variable "repositories" {
  type = list(string)
}

variable "admin_principal_arns" {
  description = "IAM user/role ARNs to grant cluster-admin access on the EKS cluster via Access Entries"
  type        = list(string)
  default     = []
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the CI role via OIDC, as \"org/repo\""
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