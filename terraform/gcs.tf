resource "google_storage_bucket" "tfstate" {
  name                        = "${google_project.this.name}-tfstate"
  location                    = "US"
  project                     = google_project.this.name
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
