terraform {
  backend "gcs" {
    bucket = "my-terraform-backend" # Replace with your bucket name
    prefix = "terraform/bigquery"      # Folder path in the bucket (optional)
    # project = "sodium-inkwell-441501-j1"       # Replace with your GCP project ID
  }
}
# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "second-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
}

# Create subnets
resource "google_compute_subnetwork" "subnet_1" {
  name          = "my-subnet-1"
  ip_cidr_range = var.ip_cidr_range_1
  region        = var.region_1
  project                 = var.project_id
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_2" {
  name          = "my-subnet-2"
  ip_cidr_range = var.ip_cidr_range_2
  region        = var.region_2
  project                 = var.project_id
  network       = google_compute_network.vpc_network.id
}


