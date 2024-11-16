terraform {
  backend "gcs" {
    bucket = "my-terraform-backend" # Replace with your bucket name
    prefix = "terraform/state"      # Folder path in the bucket (optional)
    # project = "sodium-inkwell-441501-j1"       # Replace with your GCP project ID
  }
}
