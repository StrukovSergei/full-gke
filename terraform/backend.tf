terraform {
  backend "gcs" {
    bucket  = "my-tf-state1"
    prefix  = "terraform/state"
  }
}
