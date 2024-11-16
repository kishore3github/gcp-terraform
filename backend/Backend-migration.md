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
```

Run the following Terraform commands to create the bucket:

```bash
terraform init
terraform plan
terraform apply
```

### 2. Configure the Terraform Backend
Update your main.tf file to configure the backend as GCS, by adding the following terraform block:

```hcl
terraform {
  backend "gcs" {
    bucket  = "my-terraform-backend"  # Replace with your bucket name
    prefix  = "terraform/state"       # Folder path in the bucket (optional)
    project = "your-project-id"       # Replace with your GCP project ID
  }
}
```
### 3. Migrate the Local State File
After updating the backend configuration, run the following command to initialize Terraform:

```bash
terraform init
```
Terraform will detect the backend change and prompt you to migrate your existing state to the new GCS backend:

```plaintext
Do you want to copy the existing state to the new backend? (yes)
```
Type `yes` to confirm.

###  4. Verify the Migration
1. Open the Google Cloud Console.
2. Navigate to the newly created bucket (my-terraform-backend).
3. Verify that the state file (e.g., default.tfstate) has been uploaded.

To further verify, run the following Terraform command:
```bash
terraform plan
```

This will confirm that Terraform is reading the state file from GCS

###  5. Clean Up Local State
Once the migration is successful, remove the local state files to prevent any confusion:
```bash
rm terraform.tfstate terraform.tfstate.backup
```