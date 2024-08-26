terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = ">= 3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project = var.project_id
  region = var.region
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  
  }
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}