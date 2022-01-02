terraform {
  backend "gcs" {
    bucket = "k8s-hardway-takedarut-tfstate02"
    prefix = "terraform/state"
  }
}