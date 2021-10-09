resource "google_project" "this" {
  name                = "k8s-hardway-takedarut"
  project_id          = "k8s-hardway-takedarut"
  billing_account     = "013D66-6AE1E6-BDACD0"
  auto_create_network = false
}
