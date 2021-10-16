resource "google_compute_instance" "controller" {
  for_each = toset([ "0", "1", "2" ])
  name         = "controller-${each.value}"
  machine_type = "e2-standard-2"
  zone         = "us-west1-a"

  tags = ["kubernetes-the-hard-way", "controller"]
  network_interface {
      network = google_compute_network.this.name
      network_ip = "10.240.0.1${each.value}"
      subnetwork = "kubernetes-the-hard-way"
      access_config {
          network_tier = "PREMIUM"
      }
  }
  can_ip_forward = true
  boot_disk {
      initialize_params {
          size = "200"
          image = "ubuntu-os-cloud/ubuntu-2004-lts"
      }
  }
  service_account {
      scopes = [ "compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring" ]
  }
}
