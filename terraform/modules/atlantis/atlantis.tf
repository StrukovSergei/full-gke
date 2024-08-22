# Define the Kubernetes Namespace for Atlantis
resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

# Deploy Atlantis using the Helm Chart
resource "helm_release" "atlantis" {
  name       = "atlantis"
  namespace  = kubernetes_namespace.atlantis.metadata[0].name
  chart      = "atlantis"
  repository = "https://helm.releases.hashicorp.com"
  version    = "4.2.0"  # Use the appropriate version

  values = [
    <<EOF
    data:
      config:
        atlantis.yaml:
          version: 3
          projects:
            - name: your-project-name
              dir: .
              terraform_version: v1.5.0
              autoplan:
                when_modified: ["*.tf"]
                enabled: true
    EOF
  ]

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.hosts[0].name"
    value = "atlantis.your-domain.com"  # Replace with your domain
  }

  set {
    name  = "ingress.hosts[0].path"
    value = "/"
  }

  set {
    name  = "environment.AWS_DEFAULT_REGION"
    value = "us-west-2"
  }

  set {
    name  = "vcsSecretName"
    value = "atlantis-vcs"  # You'll need to set up this Kubernetes secret
  }

  depends_on = [
    google_container_cluster.primary,
    kubernetes_namespace.atlantis
  ]
}
