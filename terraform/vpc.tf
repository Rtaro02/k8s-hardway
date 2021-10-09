resource "google_compute_network" "this" {
  project                 = google_project.this.name
  name                    = "kubernetes-the-hard-way"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "kubernetes-the-hard-way"
  ip_cidr_range = "10.240.0.0/24"
  region        = "us-west1"
  network       = google_compute_network.this.id
  project = google_project.this.name
}

resource "google_compute_firewall" "kubernetes-the-hard-way-allow-internal" {
  name    = "kubernetes-the-hard-way-allow-internal"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }     

  source_tags = ["web"]
}
