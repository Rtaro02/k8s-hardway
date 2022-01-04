resource "google_compute_network" "this" {
  project                 = local.project_id
  name                    = "kubernetes-the-hard-way"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "kubernetes"
  ip_cidr_range = "10.240.0.0/24"
  region        = local.region
  network       = google_compute_network.this.id
  project       = local.project_id
}

resource "google_compute_firewall" "kubernetes_the_hard_way_allow_internal" {
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

resource "google_compute_firewall" "kubernetes_the_hard_way_allow_external" {
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

resource "google_compute_address" "kubernetes_the_hard_way" {
  name    = "kubernetes-the-hard-way"
  region  = local.region
  project = local.project_id
}

resource "google_compute_http_health_check" "kubernetes" {
  project      = local.project_id
  name         = "kubernetes"
  description  = "Kubernetes Health Check"
  request_path = "/healthz"
  host         = "kubernetes.default.svc.cluster.local"
  port         = 80
}

resource "google_compute_firewall" "kubernetes_the_hard_way_allow_health_check" {
  name    = "kubernetes-the-hard-way-allow-health-check"
  network = google_compute_network.this.name
  project = local.project_id
  allow {
    protocol = "tcp"
  }
  source_ranges = [
    "209.85.152.0/22",
    "209.85.204.0/22",
    "35.191.0.0/16",
  ]
}

resource "google_compute_target_pool" "kubernetes_target_pool" {
  project = local.project_id
  name    = "kubernetes-target-pool"

  instances = [
    # google_compute_instance.controller[0].id,
    # google_compute_instance.controller[1].id,
    # google_compute_instance.controller[2].id,
    "us-west1-a/controller-0",
    "us-west1-a/controller-1",
    "us-west1-a/controller-2",
  ]

  health_checks = [
    google_compute_http_health_check.kubernetes.name
  ]
}

resource "google_compute_forwarding_rule" "kubernetes_forwarding_rule" {
  name       = "kubernetes-forwarding-rule"
  target     = google_compute_target_pool.kubernetes_target_pool.id
  port_range = "6443"
  ip_address = google_compute_address.kubernetes_the_hard_way.address
}

resource "google_compute_route" "kubernetes" {
  for_each = toset(["0", "1", "2"])

  name        = "kubernetes-route-10-200-${each.value}"
  dest_range  = "10.200.${each.value}.0/24"
  network     = google_compute_network.this.name
  next_hop_ip = "10.240.0.2${each.value}"
}