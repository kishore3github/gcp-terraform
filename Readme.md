# Terraform Remote Backend Migration to GCS

This guide outlines the steps to migrate an existing Terraform state file stored locally to a Google Cloud Storage (GCS) bucket for use as a remote backend.

---

## Prerequisites
1. **Google Cloud SDK**: Ensure `gcloud` is installed and authenticated.
2. **Terraform Installed**: Make sure Terraform is installed and working locally.
3. **Access to GCP Project**: You need appropriate permissions to create and manage GCS buckets.

---

## Steps to Migrate Terraform State to GCS

### 1. Create a GCS Bucket for Terraform Backend

First, create a GCS bucket for storing Terraform's state file. Add the following configuration to your Terraform `main.tf` file:

```hcl
resource "google_storage_bucket" "terraform_backend" {
  name          = "my-terraform-backend"   # Replace with your desired bucket name
  location      = "US"                     # Adjust location as needed
  storage_class = "STANDARD"               # Adjust storage class as needed

  versioning {
    enabled = true  # Enable versioning for state file history
  }
}

Run the following Terraform commands to create the bucket:

```bash
terraform init
terraform plan
terraform apply
```