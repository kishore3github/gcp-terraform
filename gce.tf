resource "google_compute_instance" "tf-gce" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "default"
    access_config {
      // This is to assign a public IP
    }
  }

  tags = ["web", "terraform"]

  metadata_startup_script = <<-EOT
    #! /bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
  EOT
}
