# Define the Google provider
provider "google" {
  project = var.project_id
  region  = "asia-south1"
}

data "google_project" "my_project" {
  # Optionally specify the project if it's not the default
  # project = "your-explicit-project-id"
}