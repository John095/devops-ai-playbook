resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace_v1" "amazon_cloudwatch" {
  metadata {
    name = "amazon-cloudwatch"
  }
}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}


resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.0"

  create_namespace = false

  values = [
    yamlencode({
      server = {
        service = {
          type = "ClusterIP"
        }
      }
      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]
}

resource "helm_release" "monitoring" {
  name      = "kube-prometheus-stack"
  namespace = kubernetes_namespace_v1.monitoring.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.21.0"

  timeout          = 600
  create_namespace = false

  values = [
    yamlencode({
      grafana = {
        service = {
          type = "ClusterIP"
        }
      }

      prometheus = {
        service = {
          type = "ClusterIP"
        }
      }

      alertmanager = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
}

resource "helm_release" "fluent_bit" {
  name      = "aws-for-fluent-bit"
  namespace = kubernetes_namespace_v1.amazon_cloudwatch.metadata[0].name

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"

  create_namespace = false

  values = [
    yamlencode({
      cloudWatch = {
        enabled          = true
        region           = "us-east-1"
        logGroupName     = "/eks/boutique/pods"
        logStreamPrefix  = "from-fluent-bit-"
      }
      # Chart's newer cloudWatchLogs output is disabled to avoid a second,
      # unconfigured log group silently failing with AccessDenied.
      cloudWatchLogs = {
        enabled = false
      }
      firehose = {
        enabled = false
      }
      kinesis = {
        enabled = false
      }
      elasticsearch = {
        enabled = false
      }
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.fluent_bit_irsa_role_arn
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.amazon_cloudwatch
  ]
}
