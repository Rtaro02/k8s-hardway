resource "google_compute_network" "this" {
  project                 = local.project_id
  name                    = "kubernetes-the-hard-way"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "kubernetes"
  ip_cidr_range = "10.240.0.0/24"
  region        = "us-west1"
  network       = google_compute_network.this.id
  project       = local.project_id
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-internal" {
  name    = "kubernetes-the-hard-way-allow-internal"
  network = google_compute_network.this.name
  project = local.project_id
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-external" {
  name    = "kubernetes-the-hard-way-allow-external"
  network = google_compute_network.this.name
  project = local.project_id
  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "default" {
  name    = "kubernetes-the-hard-way"
  region  = "us-west1"
  project = local.project_id
}
