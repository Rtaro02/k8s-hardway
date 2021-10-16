resource "google_compute_instance" "default" {
  name         = "controller-0"
  machine_type = "e2-standard-2"
  zone         = "us-west1-a"

  tags = ["kubernetes-the-hard-way", "controller"]
  network_interface {
      network = google_compute_network.this.name
      network_ip = "10.240.0.10"
      subnetwork = "kubernetes"
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
