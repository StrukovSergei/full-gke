resource "google_container_cluster" "primary" {
  name     = "gke-cluster"
  location = var.region
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
  }

  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  cluster = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
  node_count = 1

  node_config {
    machine_type = "e2-medium"
  }
}

resource "kubernetes_namespace" "atlantis" {
  metadata {
    name = "atlantis"
  }
}

module "atlantis" {
  source      = "./modules/atlantis"
  cluster_name = google_container_cluster.primary.name
  namespace   = "atlantis" 
}