resource "google_compute_instance" "controller" {
  project      = local.project_id
  for_each     = toset(["0", "1", "2"])
  name         = "controller-${each.value}"
  machine_type = "e2-standard-2"
  zone         = "us-west1-a"

  tags = ["kubernetes-the-hard-way", "controller"]
  network_interface {
    network            = google_compute_network.this.name
    network_ip         = "10.240.0.1${each.value}"
    subnetwork         = google_compute_subnetwork.this.name
    subnetwork_project = local.project_id
    access_config {
      network_tier = "PREMIUM"
    }
  }
  can_ip_forward = true
  boot_disk {
    initialize_params {
      size  = "200"
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}

resource "google_compute_instance" "worker" {
  project      = local.project_id
  for_each     = toset(["0", "1", "2"])
  name         = "worker-${each.value}"
  machine_type = "e2-standard-2"
  zone         = "us-west1-a"

  tags = ["kubernetes-the-hard-way", "worker"]
  network_interface {
    network            = google_compute_network.this.name
    network_ip         = "10.240.0.2${each.value}"
    subnetwork         = google_compute_subnetwork.this.name
    subnetwork_project = local.project_id
    access_config {
      network_tier = "PREMIUM"
    }
  }
  metadata = {
    pod-cidr = "10.200.${each.value}.0/24"
  }
  can_ip_forward = true
  boot_disk {
    initialize_params {
      size  = "200"
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}
