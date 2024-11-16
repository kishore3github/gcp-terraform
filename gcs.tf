
# resource "google_storage_bucket" "terraform_state" {
#   name     = "my-terraform-backend"
#   location = "asia-south1"  # Choose your preferred location
#   storage_class = "STANDARD"  # Choose the storage class

#   versioning {
#     enabled = true  # Enable versioning for state file history
#   }

#   lifecycle_rule {
#     action {
#       type = "Delete"
#     }
#     condition {
#       age = 30  # Delete objects older than 30 days
#     }
#   }
# }

# output "bucket_name" {
#   value = google_storage_bucket.terraform_state.name

# }

# output "bucket_id" {
#     value = google_storage_bucket.terraform_state.id

# }