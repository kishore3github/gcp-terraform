# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

# Create subnets
resource "google_compute_subnetwork" "subnet_1" {
  name          = var.subnet1_name
  ip_cidr_range = var.ip_cidr_range_1
  region        = var.region_1
  project                 = var.project_id
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet_2" {
  name          = var.subnet2_name
  ip_cidr_range = var.ip_cidr_range_2
  region        = var.region_2
  project                 = var.project_id
  network       = google_compute_network.vpc_network.id
}
