resource "google_storage_bucket" "tfstate" {
  name                        = "${local.project_id}-tfstate"
  location                    = "US"
  project                     = local.project_id
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
