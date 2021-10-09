terraform {
  backend "gcs" {
    bucket = "k8s-hardway-takedarut-tfstate"
    prefix = "terraform/state"
  }
}