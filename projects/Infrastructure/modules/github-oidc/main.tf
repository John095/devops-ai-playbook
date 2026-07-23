# GitHub Actions OIDC Provider
# Only one of these can exist per AWS account (per issuer URL).

data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.github_actions.certificates[
      length(data.tls_certificate.github_actions.certificates) - 1
    ].sha1_fingerprint
  ]
}

# Role GitHub Actions assumes via short-lived, per-run credentials.
# The "sub" condition scopes this to a single repo - any branch/tag/PR within it.
#
# GitHub now issues "immutable" subject claims by default: owner/repo names are
# suffixed with their permanent numeric IDs (e.g. "repo:owner@123/repo@456:...")
# so the claim keeps matching even if the org or repo is later renamed. Plain
# "repo:owner/repo:*" will NOT match these tokens - verified via CloudTrail
# (AssumeRoleWithWebIdentity AccessDenied events show the actual "sub" received).

data "aws_iam_policy_document" "github_actions_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${split("/", var.github_repo)[0]}@${var.github_owner_id}/${split("/", var.github_repo)[1]}@${var.github_repo_id}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_ecr" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume.json
}

# Least-privilege ECR push/pull - no admin, no other services.

data "aws_iam_policy_document" "ecr_push" {
  statement {
    sid       = "GetAuthToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"] # required: this action doesn't support resource-level scoping
  }

  statement {
    sid    = "PushPullImages"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
    resources = var.repository_arns
  }
}

resource "aws_iam_role_policy" "ecr_push" {
  name   = "ecr-push"
  role   = aws_iam_role.github_actions_ecr.id
  policy = data.aws_iam_policy_document.ecr_push.json
}
