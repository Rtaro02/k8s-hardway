#resource "google_compute_instance" "default" {
#  name         = "controller-   "
#  machine_type = "e2-standard-2"
#  zone         = "us-west1-a"
#
#  tags = ["kubernetes-the-hard-way", "controller"]
#  network_interface {
#      network = google_compute_network.this.name
#  }
#  can_ip_forward = true
#  boot_disk = {
#      initialize_params {
#          size = "200"
#          image = "ubuntu-2004-lts"
#      }
#  }
#}