resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  namespace  = kubernetes_namespace.atlantis.metadata[0].name
  chart      = "atlantis"
  repository = "https://helm.releases.hashicorp.com"
  version    = "4.2.0"  

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
    value = "atlantis.your-domain.com"  
  }

  set {
    name  = "ingress.hosts[0].path"
    value = "/"
  }

  set {
    name  = "vcsSecretName"
    value = "atlantis-vcs"  
  }

  depends_on = [
    var.cluster_name
  ]
}
