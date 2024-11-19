terraform {
  backend "gcs" {
    bucket = "my-terraform-backend" # Replace with your bucket name
    prefix = "terraform/gce"      # Folder path in the bucket (optional)
    # project = "sodium-inkwell-441501-j1"       # Replace with your GCP project ID
  }
}
# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc"
  project                 = data.google_project.my_project.project_id
  auto_create_subnetworks = false
}

# Create subnets
resource "google_compute_subnetwork" "subnet_1" {
  name          = "my-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region_1
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_2" {
  name          = "my-subnet-2"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region_2
  network       = google_compute_network.vpc_network.id
}

# Firewall rule: Allow SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.self_link
  direction = "INGRESS"

  # Priority of the rule (lower number = higher priority)
  priority = 1000

  # Source IP ranges allowed
  source_ranges = ["0.0.0.0/0", "34.49.20.125/32"]

  # Allowed protocols and ports
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
 
}

# Firewall rule: Allow all egress traffic
resource "google_compute_firewall" "allow_all_egress" {
  name    = "allow-all-egress"
  network = google_compute_network.vpc_network.self_link
  direction = "EGRESS"

  # Priority of the rule (lower number = higher priority)
  priority = 1000

  # Destination IP ranges allowed
  destination_ranges = ["0.0.0.0/0"]

  # Allowed protocols and ports
  allow {
    protocol = "all"
  }
}
