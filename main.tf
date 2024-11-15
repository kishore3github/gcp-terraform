# terraform {
#   backend "gcs" {
#     bucket  = "my-terraform-backend"
#     prefix  = "terraform/state"
#     # project = "sodium-inkwell-441501-j1"
#   }
# }


# Create a Service Account
resource "google_service_account" "first-sa" {
  account_id   = "gce-tf-sa"
  display_name = "gce-tf-sa"
  description  = "Service account has been created through"
}

resource "google_service_account" "gce-vm" {
  account_id   = "gce-vm"
  display_name = "gce-vm"
  description  = "Service account has been imported to tf"

}
# Assign Roles to the Service Account
resource "google_project_iam_member" "sa_roles" {
  for_each = toset([
    "roles/compute.admin",
    "roles/storage.admin"
  ])

  project = "sodium-inkwell-441501-j1"
  role    = each.key
  member  = "serviceAccount:${google_service_account.first-sa.email}"
}

# Output the Service Account Email
output "service_account_email" {
  value = google_service_account.first-sa.email
}
